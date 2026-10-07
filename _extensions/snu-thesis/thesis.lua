-- Convert student metadata into escaped LaTeX template values.
local function fail(message)
  error('SNU thesis: ' .. message, 0)
end
local function str(value)
  return value and pandoc.utils.stringify(value) or ''
end
local function literal(value)
  return pandoc.MetaInlines({pandoc.Str(value)})
end
local function required(map, key)
  local value = str(map[key])
  if value == '' then fail('thesis.yml에 ' .. key .. ' 값을 입력하세요.') end
  return value
end
local function date(value, english, key)
  local year, month = value:match('^(%d%d%d%d)%-(%d%d)$')
  month = tonumber(month)
  if not year or not month or month < 1 or month > 12 then
    fail(key .. '는 YYYY-MM 형식이어야 합니다.')
  end
  local months = {'January','February','March','April','May','June','July','August','September','October','November','December'}
  return english and (months[month] .. ' ' .. year) or (year .. '년 ' .. month .. '월')
end
local function markdown_file(path)
  local handle, message = io.open(path, 'r')
  if not handle then fail('파일을 읽을 수 없습니다: ' .. path .. ' (' .. tostring(message) .. ')') end
  local content = handle:read('*a'); handle:close()
  if content:match('^%s*$') then fail('빈 초록/감사문 파일입니다: ' .. path) end
  if content:match('```%s*{%s*[%a][%w_]*') then
    fail('초록 파일에는 실행 코드 청크를 넣지 마세요: ' .. path)
  end
  local doc = pandoc.read(content, 'markdown')
  -- Abstracts are prose: executable chunks and citations belong in the book body.
  doc:walk({CodeBlock = function(block)
    if block.classes:includes('r') or block.classes:includes('python') or block.classes:includes('{r}') or block.classes:includes('{python}') then
      fail('초록 파일에는 실행 코드 청크를 넣지 마세요: ' .. path)
    end
  end, Cite = function() fail('초록 파일의 문헌 인용은 지원하지 않습니다: ' .. path) end})
  return pandoc.MetaBlocks({pandoc.RawBlock('latex', pandoc.write(doc, 'latex'))})
end
local function keywords(map, key, maximum)
  local values = map[key]
  if not values or pandoc.utils.type(values) ~= 'List' or #values < 1 or #values > maximum then
    fail(key .. '는 1~' .. maximum .. '개의 YAML 목록이어야 합니다.')
  end
  local result = {}
  for _, value in ipairs(values) do
    if str(value) == '' then fail(key .. '에 빈 주요어가 있습니다.') end
    table.insert(result, str(value))
  end
  return literal(table.concat(result, ', '))
end
function Meta(meta)
  local t = meta.thesis
  if not t then fail('thesis.yml의 thesis 설정이 필요합니다.') end
  local language = str(meta['thesis-language'] or t.language)
  local degree = str(meta['thesis-degree'] or t.degree)
  if language ~= 'ko' and language ~= 'en' then fail('language는 ko 또는 en이어야 합니다.') end
  if degree ~= 'master' and degree ~= 'phd' then fail('degree는 master 또는 phd이어야 합니다.') end
  local en = language == 'en'
  local primary, secondary = en and 'en' or 'ko', en and 'ko' or 'en'
  local kind_ko = degree == 'master' and '석사' or '박사'
  local kind_en = degree == 'master' and "Master’s Thesis" or 'Ph.D. Dissertation'
  local field_ko, field_en = required(t, 'degree-field-ko'), required(t, 'degree-field-en')
  local name, advisor = required(t, 'name-' .. primary), required(t, 'advisor-' .. primary)
  local maximum = tonumber(str(t['max-keywords']) or '') or 6
  if maximum < 1 or maximum > 8 or maximum % 1 ~= 0 then fail('max-keywords는 1~8 사이 정수여야 합니다.') end
  local s = pandoc.MetaMap({})
  local function put(key, value) s[key] = literal(value) end
  s.english = pandoc.MetaBool(en); s.korean = pandoc.MetaBool(not en)
  put('title-primary', required(t, 'title-' .. primary))
  put('title-secondary', required(t, 'title-' .. secondary))
  for _, pair in ipairs({{'subtitle-primary', primary}, {'subtitle-secondary', secondary}}) do
    local value = str(t['subtitle-' .. pair[2]])
    if value ~= '' then put(pair[1], value) end
  end
  put('degree-label', en and (kind_en .. ' of ' .. field_en) or (field_ko .. kind_ko .. ' 학위논문'))
  put('school', required(t, 'school-' .. primary))
  put('school-secondary', required(t, 'school-' .. secondary))
  put('department', required(t, 'department-' .. primary))
  put('department-secondary', required(t, 'department-' .. secondary))
  put('name', name); put('name-secondary', required(t, 'name-' .. secondary))
  put('advisor', advisor); put('advisor-label', en and 'Supervisor:' or '지도교수')
  put('student-number', required(t, 'student-number'))
  put('graduation-date', date(required(t, 'graduation-date'), en, 'graduation-date'))
  put('submission-date', date(required(t, 'submission-date'), en, 'submission-date'))
  put('approval-date', date(required(t, 'approval-date'), en, 'approval-date'))
  put('submission-text', en and ((degree == 'master' and 'Submitting a master’s thesis of ' or 'Submitting a Ph.D. dissertation of ') .. field_en) or ('이 논문을 ' .. field_ko .. kind_ko .. ' 학위논문으로 제출함'))
  put('confirmation-text', en and ('Confirming the ' .. (degree == 'master' and 'master’s thesis' or 'Ph.D. dissertation') .. ' written by ' .. name) or (name .. '의 ' .. kind_ko .. ' 학위논문을 인준함'))
  put('seal-label', en and '(Seal)' or '(인)')
  local committee = t['committee-' .. degree]
  local count = degree == 'master' and 3 or 5
  if not committee or #committee ~= count then fail('committee-' .. degree .. '에는 심사위원 ' .. count .. '명이 필요합니다.') end
  local advisor_ko = required(t, 'advisor-ko')
  if required(committee[1], 'name-ko') == advisor_ko then fail('지도교수는 심사위원장이 될 수 없습니다.') end
  if required(committee[count], 'name-ko') ~= advisor_ko then fail('지도교수를 심사위원 목록의 마지막에 입력하세요.') end
  s.committee = pandoc.MetaList({})
  for index, member in ipairs(committee) do
    local role = index == 1 and (en and 'Chair' or '위원장') or index == 2 and (en and 'Vice Chair' or '부위원장') or (en and 'Examiner' or '위원')
    s.committee:insert(pandoc.MetaMap({role = literal(role), name = literal(required(member, 'name-' .. primary))}))
  end
  put('abstract-primary-label', en and 'Abstract' or '초록')
  put('abstract-secondary-label', en and '국문초록' or 'Abstract')
  put('keywords-label', en and 'Keywords' or '주요어')
  put('keywords-secondary-label', en and '주요어' or 'Keywords')
  put('student-number-label', en and 'Student Number' or '학번')
  put('student-number-secondary-label', en and '학번' or 'Student Number')
  put('contents-label', en and 'Table of Contents' or '목차')
  put('tables-label', en and 'List of Tables' or '표 목차')
  put('figures-label', en and 'List of Figures' or '그림 목차')
  put('chapter-label', en and 'Chapter' or '장')
  put('table-label', en and 'Table' or '표'); put('figure-label', en and 'Figure' or '그림')
  s['abstract-primary'] = markdown_file(required(t, 'abstract-' .. primary))
  s['abstract-secondary'] = markdown_file(required(t, 'abstract-' .. secondary))
  s['keywords-primary'] = keywords(t, 'keywords-' .. primary, maximum)
  s['keywords-secondary'] = keywords(t, 'keywords-' .. secondary, maximum)
  if str(t.acknowledgements) ~= '' then
    s.acknowledgements = markdown_file(str(t.acknowledgements))
    put('acknowledgements-label', en and 'Acknowledgements' or '감사의 글')
  end
  meta.snu = s
  meta.title = literal(required(t, "title-" .. primary))
  meta.author = literal(name)
  meta["title-meta"] = meta.title
  meta["author-meta"] = meta.author
  return meta
end

-- Quarto synthesizes an empty chapter for the book's required index.qmd.
-- Drop that heading so the introduction is Chapter 1 and there is no blank page.
function Header(header)
  if header.level == 1 and pandoc.utils.stringify(header.content) == '' then
    return {}
  end
end

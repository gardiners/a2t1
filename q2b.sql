SELECT
  c.Name Country,
  l.Percentage,
  a.Name Capital
FROM countrylanguage l
INNER JOIN country c ON l.CountryCode = c.Code
INNER JOIN city a ON c.Capital = a.ID
WHERE
  l.Language = 'English'
  AND l.Percentage > 50;
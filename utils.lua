local utils = {}

function utils.inc(a, b)
  a = a + b
end

function utils.dec(a, b)
  a = a - b
end

function utils.mul(a, b)
  a = a * b
  return a
end

function utils.div(a, b)
  a = a / b
  return a
end

return utils

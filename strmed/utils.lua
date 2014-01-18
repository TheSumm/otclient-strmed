function getThingCategoryName(category)
  return ThingCategoryNames[category]
end

function getThingCategoryByName(name)
  for k, v in pairs(ThingCategoryNames) do
    if v:lower() == name:lower() then
      return k
    end
  end

  return nil
end
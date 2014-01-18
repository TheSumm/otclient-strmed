LogColors = {
    Default = 'white',
    Error   = 'red',
    Warning = 'yellow',
    Success = 'green',
    Event   = 'teal'
}

ThingCategory = {
    CategoryItem = 0,
    CategoryCreature = 1,
    CategoryEffect = 2,
    CategoryMissile = 3,
    CategoryInvalid = 4
}

ThingCategories = {
    ThingCategory.CategoryItem,
    ThingCategory.CategoryCreature,
    ThingCategory.CategoryEffect,
    ThingCategory.CategoryMissile,
    ThingCategory.CategoryInvalid
}

ThingCategoryNames = {
    [ThingCategory.CategoryItem] = 'Items',
    [ThingCategory.CategoryCreature] = 'Creatures',
    [ThingCategory.CategoryEffect] = 'Effects',
    [ThingCategory.CategoryMissile] = 'Missiles',
    [ThingCategory.CategoryInvalid] = 'Invalid'
}
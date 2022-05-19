//
//  SearchKeywords.swift
//  Dinecraft
//
//  Created by Ethan Fitzgerald on 15/5/2022.
//
//  Classes:
//      Keywords

import Foundation

//This class stores all the fruit and vegetable keywords for building an API search, and the associated RNG functions for it
class Keywords {
    //Data
    public let fruits = [
      "Apple",
      "Apricot",
      "Avocado",
      "Banana",
      "Berries",
      "Breadfruit",
      "Carob",
      "Cherry",
      "Citron",
      "Coconut",
      "Date",
      "Dragon",
      "Durian",
      "Fig",
      "Fruit",
      "Ginger",
      "Grape",
      "Currant",
      "Raisin",
      "Grapefruit",
      "Guava",
      "Jackfruit",
      "Jujube",
      "Kiwifruit",
      "Kumquat",
      "Lemon",
      "Lime",
      "Longan",
      "Loquat",
      "Lucuma",
      "Lychee",
      "Mango",
      "Mangosteen",
      "Melons",
      "Nance",
      "Nectarine",
      "Noni",
      "Oranges",
      "Mandarin",
      "Navel",
      "Seville",
      "Valencia",
      "Papaya",
      "Peach",
      "Pear",
      "Persimmon",
      "Pineapple",
      "Plantain",
      "Plum",
      "Damson",
      "Prunes",
      "Pomegranate",
      "Pomelo",
      "Quince",
      "Rambutan",
      "Rhubarb",
      "Starfruit",
      "Tamarillo",
      "Tamarind",
      "Tangerine",
      "Tangelo",
      "Tomato",
    ]
    
    public let vegetables = [
        "Artichoke",
        "Arugula",
        "Asparagus",
        "Avocado",
        "Bamboo",
        "Bean",
        "Beet",
        "Broccoli",
        "Brussel",
        "Cabbage",
        "Calabash",
        "Capers",
        "Carrot",
        "Cauliflower",
        "Celery",
        "Celtuce",
        "Chayote",
        "Corn",
        "Cucumber",
        "Gherkin",
        "Edamame",
        "Endive",
        "Escarole",
        "Fennel",
        "Fiddlehead",
        "Galangal",
        "Garlic",
        "Ginger",
        "Kale",
        "Kohlrabi",
        "Mustard",
        "Rapini",
        "Spinach",
        "Horseradish",
        "Jícama",
        "Kale",
        "Curly",
        "Lacinato",
        "Ornamental",
        "Kohlrabi",
        "Leeks",
        "Lemongrass",
        "Lettuce",
        "Iceberg",
        "Romaine",
        "Lotus",
        "Mushroom",
        "Nopales",
        "Okra",
        "Olive",
        "Onion",
        "Parsley",
        "Parsnip",
        "Peas",
        "Pepper",
        "Plantain",
        "Potato",
        "Pumpkin",
        "Purslane",
        "Radicchio",
        "Radish",
        "Rutabaga",
        "Shallots",
        "Spinach",
        "Squash",
        "Taro",
        "Tomatillo",
        "Tomato",
        "Turnip",
        "Watercress",
        "Yams",
        "Zucchini"
    ]
    
    
    //Functions
    func GetRandomFruit() -> String { //Returns a random unwrapped String from the fruits array
        return fruits.randomElement()!
    }
    
    func GetRandomVegetable() -> String { //Returns a random unwrapped String from the vegetables array
        return vegetables.randomElement()!
    }
    
    func GetRandomKeyword() -> String { //Returns a random String from either the fruits array or the vegetables array
        if Bool.random() {
            return GetRandomFruit()
        } else {
            return GetRandomVegetable()
        }
    }
}

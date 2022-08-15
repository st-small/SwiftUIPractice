//
//  RecipesViewModel.swift
//  RecipeSaver
//
//  Created by Stanly Shiyanovskiy on 15.08.2022.
//

import Foundation

final class RecipesViewModel: ObservableObject {
    
    @Published private(set) var recipes: [Recipe] = []
    
    init() {
        recipes = Recipe.all
    }
    
    func addRecipe(recipe: Recipe) {
        recipes.append(recipe)
    }
}

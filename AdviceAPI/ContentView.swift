//
//  ContentView.swift
//  AdviceAPI
//
//  Created by James Meegan on 4/8/23.
//

import SwiftUI


struct ContentView: View {
    @State var advice = ""

    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack {
                Text("Advice of the Day")
                    .font(.system(size: 36, weight: .bold))
                    .fontWeight(.heavy)
                    .foregroundColor(.red)
                
                Spacer() // add a spacer to push the quote text view to the middle

                Text(advice)
                    .font(.system(size: 32, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                    .shadow(color: .black, radius: 12) // add drop shadow

                Spacer() // add another spacer to push the button to the bottom

                Button(action: {
                    // call API to refresh advice
                    callAPI { result in
                        DispatchQueue.main.async {
                            self.advice = result
                        }
                    }
                }) {
                    Text("Refresh")
                        .font(.system(size: 30, weight: .bold))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 100)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                
            }
        }
        .onAppear {
            // call API for initial advice
            callAPI { result in
                DispatchQueue.main.async {
                    self.advice = result
                }
            }
        }
    }



}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // Return a preview of the ContentView.
    }
}

import Foundation

func callAPI(completion: @escaping (String) -> Void){
    guard let url = URL(string: "https://api.adviceslip.com/advice") else{
        return
    }

    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        if let data = data, let apiResponse = try? JSONDecoder().decode(APIResponse.self, from: data) {
            completion(apiResponse.slip.advice) // Call the completion handler with the advice string.
        }
    }

    task.resume() // Start the data task.
}

struct APIResponse: Codable {
    let slip: Slip // Declare a nested struct to hold the advice slip.
}

struct Slip: Codable {
    let id: Int // Declare a property to hold the advice slip ID.
    let advice: String // Declare a property to hold the advice string.
}


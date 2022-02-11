//
//  EmptyView.swift
//  IamAZone
//
//  Created by Mostafa Gamal on 2021-02-13.
//  Copyright © 2021 MosCD. All rights reserved.
//

import SwiftUI

protocol EmptyViewHandler: AnyObject {
    func didTapActionButton()
}
struct FREmptyViewModel {
    let image: UIImage?
    let title: String?
    let description: String?
    let callToAction: String?
}

struct EmptyView: View {
    @State var model: FREmptyViewModel
    weak var handler: EmptyViewHandler?

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let img = model.image {
                Image(uiImage: img)
                    .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.secondary)
                    .opacity(0.3)
                    
            }
            if let title = model.title {
                Text(title)
                    .bold()
                    .font(.title)
                    .offset(CGSize(width: 0, height: 30))
                    .opacity(0.8)
            }
            if let desc = model.description {
                Text(desc)
                    .font(.caption)
                    .offset(CGSize(width: 0, height: 40))
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 20)
                    .opacity(0.5)
            }
            Spacer().frame(height: 50)
            if model.callToAction != nil {
                Button(action: {
                    self.handler?.didTapActionButton()
                }) {
                    Text(model.callToAction!)
                        .foregroundColor(.white)
                        .bold()
                }
                .frame(width: 300, height: 50, alignment: .center)
                .background(Color.blue.opacity(0.9))
                .cornerRadius(7)
                .offset(CGSize(width: 0.0, height: 20.0))
            }
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        let model = FREmptyViewModel(image: nil,
                                      title: "Test",
                                      description: "Description of SwiftUI empty view",
                                      callToAction: nil)
        return EmptyView(model: model)
    }
}



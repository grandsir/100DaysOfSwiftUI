//
//  CardView.swift
//  Flashzilla
//
//  Created by Mehmet Atabey on 8.08.2021.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    let duration = 0.5
    let amount : Double = 180
    let card: Card
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @State private var degrees : Angle = .degrees(0)
    @State private var feedback = UINotificationFeedbackGenerator()
    var removal : (() -> Void)? = nil

    var body: some View {
        let opacity = 1 - Double(abs(offset.width / 50))
        return ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(differentiateWithoutColor ? Color.white : Color.white.opacity(opacity))
                .background(
                    differentiateWithoutColor ? nil :
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width > 0 ? Color.green : Color.red)
                )
                .shadow(radius: 10)
            if isShowingAnswer {
                Text(card.answer)
                    .font(.title)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 1)
                    .shadow(color: .black, radius: 1)
            }
            else {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
        }
        .accessibility(addTraits: .isButton)
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: self.offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                    self.feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if self.offset.width > 0 {
                            self.feedback.notificationOccurred(.success)
                        }
                        else {
                            self.feedback.notificationOccurred(.error)
                        }
                        self.removal?()
                    }

                    else {
                        withAnimation(Animation.interpolatingSpring(stiffness: 3, damping: 0.8)
                                        .speed(10)) {
                            self.offset = .zero
                        }
                    }
                }
        )
        .rotation3DEffect(
            degrees,
            axis: (x: 0.0, y: 1.0, z: 0.0),
            anchor: .center,
            anchorZ: 0.0,
            perspective: 1
        )
        .onTapGesture(perform: {
            withAnimation(Animation.easeInOut(duration: self.duration)) {
                self.degrees += .degrees(amount)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(duration * 1000) / 2)) {
                self.degrees += .degrees(amount)
                self.isShowingAnswer.toggle()
            }
        })

    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}


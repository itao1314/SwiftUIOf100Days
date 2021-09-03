//
//  ContentView.swift
//  Drawing
//
//  Created by 陶涛 on 2021/8/24.
//

import SwiftUI

struct ContentView: View {
    @State private var thickness: CGFloat = 10
    var body: some View {
        Arrow(thickness: thickness)
            .stroke(Color.blue)
            .onTapGesture {
                withAnimation {
                    thickness += 2
                }
            }
    }
}

struct Arrow: Shape {
    
    var animatableData: CGFloat {
        get {
            thickness
        }
        
        set {
            thickness = newValue
        }
    }
    
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX -  thickness, y: rect.midY + thickness))
        path.addLine(to: CGPoint(x: rect.maxX -  thickness, y: rect.midY + thickness / 2))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY + thickness / 2))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY - thickness / 2))
        path.addLine(to: CGPoint(x: rect.maxX - thickness, y: rect.midY - thickness / 2))
        path.addLine(to: CGPoint(x: rect.maxX - thickness, y: rect.midY - thickness))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = CGFloat(outerRadius)
        let innerRadius = CGFloat(innerRadius)
        let distance = CGFloat(distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(CGFloat.pi * 2 * outerRadius / CGFloat(divisor)) * amount
        var path = Path()
        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
            
            x += rect.width / 2
            y += rect.height / 2
            
            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        return path
    }
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        if b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        return a
    }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(Double(rows), Double(rows))
        }
        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                if (row + column).isMultiple(of: 2) {
                    let startX = CGFloat(column) * columnSize
                    let startY = CGFloat(row) * rowSize
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        return path
    }
}

struct Trapezoid: Shape {
    
    var animatableData: CGFloat {
        get {
            insetAmount
        }
        set {
            insetAmount = newValue
        }
    }
    
    var insetAmount: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        return path
    }
    
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0 ..< steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(color(for: value, brightness: 1), lineWidth: 2)
                //                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                //                    self.color(for: value, brightness: 1),
                //                    self.color(for: value, brightness: 0.5)
                //                ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
            .drawingGroup()
        }
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        if targetHue > 1 {
            targetHue -= 1
        }
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
    
}

struct Flower: Shape {
    var petalOffset: Double = 20
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
            let rotatedPetal = originalPetal.applying(position)
            path.addPath(rotatedPetal)
        }
        return path
    }
    
}

struct Arc: Shape, InsettableShape {
    
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
    
    
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

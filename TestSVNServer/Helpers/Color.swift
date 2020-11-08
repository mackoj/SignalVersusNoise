//
//  Color.swift
//  TCA Debugger
//
//  Created by Jeffrey Macko on 04/11/2020.
//

import SwiftUI

extension Color {
  static var random : Color {
    Color(
      red: Double.random(in: 0.0 ..< 1.0),
      green: Double.random(in: 0.0 ..< 1.0),
      blue: Double.random(in: 0.0 ..< 1.0)
    )
  }
}

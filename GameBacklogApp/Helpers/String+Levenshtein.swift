//
//  String+Levenshtein.swift
//  GameBacklogApp
//
//  Created by Берлинский Ярослав Владленович on 20.06.2025.
//

import Foundation

extension String {
    func similarity(to other: String) -> Double {
        let lhs = Array(self.lowercased())
        let rhs = Array(other.lowercased())
        let m = lhs.count, n = rhs.count

        guard m > 0 && n > 0 else { return m == n ? 1 : 0 }

        var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
        for i in 0...m { dp[i][0] = i }
        for j in 0...n { dp[0][j] = j }

        for i in 1...m {
            for j in 1...n {
                let deletion = dp[i - 1][j]
                let insertion = dp[i][j - 1]
                let substitution = dp[i - 1][j - 1]
                dp[i][j] = lhs[i - 1] == rhs[j - 1] ? substitution : 1 + min(min(deletion, insertion), substitution)
            }
        }
        let distance = dp[m][n]
        let maxLen = max(m, n)
        return 1 - Double(distance) / Double(maxLen)
    }
}

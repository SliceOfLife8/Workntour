//
//  CompanyUpdatedBody.swift
//  workntour
//
//  Created by Chris Petimezas on 4/12/22.
//

import Foundation

struct CompanyUpdatedBody: Codable {
    let updatedCompanyHostProfile: CompanyHostProfileDto
    let media: Media?
}

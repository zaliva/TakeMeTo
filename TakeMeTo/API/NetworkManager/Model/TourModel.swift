

import Foundation

struct TourDataModel: Codable {
    let id: String
    let title: [TourTitleModel]
    let points: [TourPointModel]
    let userTours: [UserToursModel]
    let src: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, points, userTours, src
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode([TourTitleModel].self, forKey: .title)
        points = try container.decode([TourPointModel].self, forKey: .points)
        userTours = try container.decode([UserToursModel].self, forKey: .userTours)
        src = try container.decode(String.self, forKey: .src)
    }
}

// MARK: - UserToursModel
struct UserToursModel: Codable {
    let id, tourID: String
    let user: UserModel
    let userID: String
    let userTourPoints: [UserTourPointsModel]
    let type: Int

    enum CodingKeys: String, CodingKey {
        case id
        case tourID = "tourId"
        case user
        case userID = "userId"
        case userTourPoints, type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        tourID = try container.decode(String.self, forKey: .tourID)
        user = try container.decode(UserModel.self, forKey: .user)
        userID = try container.decode(String.self, forKey: .userID)
        userTourPoints = try container.decode([UserTourPointsModel].self, forKey: .userTourPoints)
        type = try container.decode(Int.self, forKey: .type)
    }
}

// MARK: - UserTourPointElement
struct UserTourPointsModel: Codable {
    let id: String
    let status: Int
    let userTourID: String
    let tourPoint: TourPointModel
    let tourPointID: String
    let tourPointAssigments: [TourAssigmentModel]

    enum CodingKeys: String, CodingKey {
        case id, status
        case userTourID = "userTourId"
        case tourPoint
        case tourPointID = "tourPointId"
        case tourPointAssigments
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(Int.self, forKey: .status)
        userTourID = try container.decode(String.self, forKey: .userTourID)
        tourPoint = try container.decode(TourPointModel.self, forKey: .tourPoint)
        tourPointID = try container.decode(String.self, forKey: .tourPointID)
        tourPointAssigments = try container.decode([TourAssigmentModel].self, forKey: .tourPointAssigments)
    }
}

// MARK: - Point
struct TourPointModel: Codable {
    let tourID: String
    let source: [TourTitleModel]
    let assigments: [TourAssigmentElement]?
    let usersPoint: [UsersPoint]?
    let order: Int
    let id: String
    let type: Int
    let title: [TourTitleModel]
    let distance: Int
    let lat, lng: Double

    enum CodingKeys: String, CodingKey {
        case tourID = "tourId"
        case source, assigments, usersPoint, order, id, type, title, distance, lat, lng
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tourID = try container.decode(String.self, forKey: .tourID)
        source = try container.decode([TourTitleModel].self, forKey: .source)
        assigments = try? container.decode([TourAssigmentElement]?.self, forKey: .assigments)
        usersPoint = try? container.decode([UsersPoint]?.self, forKey: .usersPoint)
        order = try container.decode(Int.self, forKey: .order)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(Int.self, forKey: .type)
        title = try container.decode([TourTitleModel].self, forKey: .title)
        distance = try container.decode(Int.self, forKey: .distance)
        lat = try container.decode(Double.self, forKey: .lat)
        lng = try container.decode(Double.self, forKey: .lng)
    }
}

// MARK: - TourDataTitleModel
struct TourTitleModel: Codable {
    let id: String
    let language: TourLanguage
    let translation: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        language = try container.decode(TourLanguage.self, forKey: .language)
        translation = try container.decode(String.self, forKey: .translation)
    }
}

enum TourLanguage: String, Codable {
    case en = "en"
}

// MARK: - AssigmentElement
struct TourAssigmentElement: Codable {
    let id, tourPointID: String
    let title: [TourTitleModel]
    let userAssigments: [TourAssigmentModel]
    let tourPoint: TourPointModel?

    enum CodingKeys: String, CodingKey {
        case id
        case tourPointID = "tourPointId"
        case title, userAssigments, tourPoint
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        tourPointID = try container.decode(String.self, forKey: .tourPointID)
        title = try container.decode([TourTitleModel].self, forKey: .title)
        userAssigments = try container.decode([TourAssigmentModel].self, forKey: .userAssigments)
        tourPoint = try? container.decodeIfPresent(TourPointModel.self, forKey: .tourPoint)
    }
}

// MARK: - Assigment
struct TourAssigmentModel: Codable {
    let id: String
    let userTourPoint: UserAssigmentUserTourPoint?
    let userTourPointID, assigmentID: String
    let state: Bool
    let assigment: TourAssigmentElement?

    enum CodingKeys: String, CodingKey {
        case id, userTourPoint
        case userTourPointID = "userTourPointId"
        case assigmentID = "assigmentId"
        case state, assigment
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userTourPoint = try? container.decodeIfPresent(UserAssigmentUserTourPoint.self, forKey: .userTourPoint)
        userTourPointID = try container.decode(String.self, forKey: .userTourPointID)
        assigmentID = try container.decode(String.self, forKey: .assigmentID)
        state = try container.decode(Bool.self, forKey: .state)
        assigment = try? container.decodeIfPresent(TourAssigmentElement.self, forKey: .assigment)
    }
}

// MARK: - UserTourPointUserTour
struct UserTourPointUserTour: Codable {
    let id, tourID: String
    let user: UserModel
    let userID: String
    let userTourPoints: [UserTourPointsModel]?
    let type: Int

    enum CodingKeys: String, CodingKey {
        case id
        case tourID = "tourId"
        case user
        case userID = "userId"
        case userTourPoints, type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        tourID = try container.decode(String.self, forKey: .tourID)
        user = try container.decode(UserModel.self, forKey: .user)
        userID = try container.decode(String.self, forKey: .userID)
        userTourPoints = try? container.decode([UserTourPointsModel]?.self, forKey: .userTourPoints)
        type = try container.decode(Int.self, forKey: .type)
    }
}

// MARK: - UserAssigmentUserTourPoint
struct UserAssigmentUserTourPoint: Codable {
    let id: String
    let status: Int
    let userTour: UserTourPointUserTour
    let userTourID, tourPointID: String
    let tourPointAssigments: [TourAssigmentModel]?

    enum CodingKeys: String, CodingKey {
        case id, status, userTour
        case userTourID = "userTourId"
        case tourPointID = "tourPointId"
        case tourPointAssigments
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(Int.self, forKey: .status)
        userTour = try container.decode(UserTourPointUserTour.self, forKey: .userTour)
        userTourID = try container.decode(String.self, forKey: .userTourID)
        tourPointID = try container.decode(String.self, forKey: .tourPointID)
        tourPointAssigments = try? container.decode([TourAssigmentModel]?.self, forKey: .tourPointAssigments)
    }
}

// MARK: - UsersPoint
struct UsersPoint: Codable {
    let id: String
    let status: Int
    let userTour: UserTourPointUserTour
    let userTourID, tourPointID: String
    let tourPointAssigments: [TourAssigmentModel]?

    enum CodingKeys: String, CodingKey {
        case id, status, userTour
        case userTourID = "userTourId"
        case tourPointID = "tourPointId"
        case tourPointAssigments
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(Int.self, forKey: .status)
        userTour = try container.decode(UserTourPointUserTour.self, forKey: .userTour)
        userTourID = try container.decode(String.self, forKey: .userTourID)
        tourPointID = try container.decode(String.self, forKey: .tourPointID)
        tourPointAssigments = try? container.decode([TourAssigmentModel]?.self, forKey: .tourPointAssigments)
    }
}

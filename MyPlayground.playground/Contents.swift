import PlaygroundSupport
import SwiftUI

// MARK: - JSON编码与解码

// MARK: struct的编解码

struct User {
    var name: String
    var age: Int
}

let user = User(name: "mjt", age: 6)

// 使User变为Encodable的，因为User内部所有属性都是Encodable的
extension User: Encodable {}

extension User: Decodable {}

let data = try! JSONEncoder().encode(user) // 编码
let myUser = try! JSONDecoder().decode(User.self, from: data) // 解码


// MARK: String类型的Json -> struct

let dataFromString = Data("""
{
"id":13,
"firstName": "mjt"
}
""".utf8)

struct Response: Decodable{
    var id: Int
    var firstName: String
}

let res: Response = try! JSONDecoder().decode(Response.self, from: dataFromString)

print(res)


// MARK: JSON中的key与struct中的key不一样时（自定义做法）

let dataFromString2 = Data("""
{
"id":13,
"firstName": "mjt"
}
""".utf8)

struct Response2{
    var id: Int
    var name: String
}

extension Response2: Decodable{
    // json中的key
    enum CodingKeys: CodingKey{
        case id, firstName
    }
    
    // 手动解码
    init(from decoder: Decoder) throws {
        // 建立一个container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // 通过CodingKey从Container中拿到资料
        // 把资料放进属性，启动类型
        self.id = try container.decode(Int.self, forKey: CodingKeys.id)
        self.name = try container.decode(String.self, forKey: CodingKeys.firstName)
        
    }
}

extension Response2: Encodable{
    // 手动编码
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: CodingKeys.id)
        try container.encode(name, forKey: CodingKeys.firstName)
    }
}

let res2: Response2 = try! JSONDecoder().decode(Response2.self, from: dataFromString2)
let data2 = try! JSONEncoder().encode(res2)
let string2 = String(data: data2, encoding: .utf8)

// MARK: JSON中的key与struct中的key不一样时（简单做法）

let dataFromString3 = Data("""
{
"id":13,
"firstName": "mjt"
}
""".utf8)

struct Response3{
    var id: Int
    var name: String
}


extension Response3: Codable{
    enum CodingKeys: String,CodingKey{
        case id
        case name = "firstName"
    }
}

// 解码
let res3: Response3 = try! JSONDecoder().decode(Response3.self, from: dataFromString3)
// 编码
let data3: Data = try! JSONEncoder().encode(res3)
let string3: String = String(data: data3, encoding: .utf8)!


// MARK: 复杂JSON的解析

let dataFromString4 = Data("""
{
    "id":13,
    "firstName":"Ethan",
    "lastName":"William",
    "friends":[
        {"id":1},
        {"id":8}
    ]
}
""".utf8)

struct User2: Decodable{
    var id: Int
    var name: String
    var friendID:[Int]
    
    enum CodingKeys: CodingKey{
        case id
        case firstName
        case lastName
        case friends
    }
    
    enum FriendIDContainerCodingKeys: CodingKey{
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container[.id] // self.id = try container.decode(Int.self, forKey: .id)
        let firstName: String = try container[.firstName]
        let lastName: String = try container[.lastName]
        self.name = "\(firstName) \(lastName)"
        
        /// 解析 "friends":[{"id":1},{"id":8}] 中的内容
        ///  - V1：简化版本
        ///     self.friendID = try container[.friends]
        ///         还要记得写以下部分:
        ///         struct FriendID: Decodable{
        ///            var id: Int
        ///         }
        ///         同时，self.friendID的类型需要为[FriendID]
        ///  - V2：详细版本
        var ids = [Int]()
        var friendContainer = try container.nestedUnkeyedContainer(forKey: .friends)
        while !friendContainer.isAtEnd{
            let friendIDContainer = try friendContainer.nestedContainer(keyedBy: FriendIDContainerCodingKeys.self)
            ids.append(try friendIDContainer[.id])
        }
        self.friendID = ids
    }
}

let user2: User2 = try! JSONDecoder().decode(User2.self, from: dataFromString4)


// 20:01

/// 简化书写
/// FROM: try container.decode(Int.self, forKey: .id)
/// TO:   try container[.id]
extension KeyedDecodingContainer{
    subscript<T: Decodable>(_ key: Key) -> T{
        get throws{
            try self.decode(T.self, forKey: key)
        }
    }
}



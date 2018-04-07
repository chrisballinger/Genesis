
public struct Option: Decodable {

    public var name: String
    public var required: Bool
    public var question: String?
    public var value: String?
    public var type: OptionType
    public var branch: [String: TemplateSection]
    public var repeatAnswer: String?
    public var set: String
    public var choices: [String]
    public var childType: OptionType?
    public var options: [Option]

    public enum OptionType: String, Decodable {
        case string
        case boolean
        case choice
        case array
    }

    public init(name: String, value: String? = nil, type: OptionType = .string, set: String? = nil, question: String? = nil, repeatAnswer: String? = nil, required: Bool = true, choices: [String] = [], branch: [String: TemplateSection] = [:], options: [Option] = []) {
        self.name = name
        self.value = value
        self.type = type
        self.set = set ?? name
        self.required = required
        self.choices = choices
        self.repeatAnswer = repeatAnswer
        self.question = question
        self.branch = branch
        self.options = options
    }

    enum CodingKeys: CodingKey {
        case name
        case value
        case required
        case question
        case type
        case branch
        case repeatAnswer
        case set
        case choices
        case childType
        case options
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let name = try container.decode(String.self, forKey: .name)
        self.name = name
        set = try container.decodeIfPresent(String.self, forKey: .set) ?? name
        value = try container.decodeIfPresent(String.self, forKey: .value)
        type = try container.decodeIfPresent(OptionType.self, forKey: .type) ?? .string
        childType = try container.decodeIfPresent(OptionType.self, forKey: .childType)
        choices = try container.decodeIfPresent([String].self, forKey: .choices) ?? []
        required = try container.decodeIfPresent(Bool.self, forKey: .required) ?? false
        question = try container.decodeIfPresent(String.self, forKey: .question)
        branch = try container.decodeIfPresent([String: TemplateSection].self, forKey: .branch) ?? [:]
        repeatAnswer = try container.decodeIfPresent(String.self, forKey: .repeatAnswer)
        options = try container.decodeIfPresent([Option].self, forKey: .options) ?? []
    }
}

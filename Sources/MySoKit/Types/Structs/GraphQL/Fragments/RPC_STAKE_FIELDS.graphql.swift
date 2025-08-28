// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct RPC_STAKE_FIELDS: MySoKit.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment RPC_STAKE_FIELDS on StakedMys { __typename principal activatedEpoch { __typename epochId referenceGasPrice } stakeStatus requestedEpoch { __typename epochId } activatedEpoch { __typename epochId } contents { __typename json } address estimatedReward }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.StakedMySo }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("principal", MySoKit.BigIntApollo?.self),
    .field("activatedEpoch", ActivatedEpoch?.self),
    .field("stakeStatus", GraphQLEnum<MySoKit.StakeStatusApollo>.self),
    .field("requestedEpoch", RequestedEpoch?.self),
    .field("contents", Contents?.self),
    .field("address", MySoKit.MySoAddressApollo.self),
    .field("estimatedReward", MySoKit.BigIntApollo?.self)
  ] }

  /// The MYS that was initially staked.
  public var principal: MySoKit.BigIntApollo? { __data["principal"] }
  /// The epoch at which this stake became active.
  public var activatedEpoch: ActivatedEpoch? { __data["activatedEpoch"] }
  /// A stake can be pending, active, or unstaked
  public var stakeStatus: GraphQLEnum<MySoKit.StakeStatusApollo> { __data["stakeStatus"] }
  /// The epoch at which this object was requested to join a stake pool.
  public var requestedEpoch: RequestedEpoch? { __data["requestedEpoch"] }
  /// Displays the contents of the Move object in a JSON string and through GraphQL types. Also
  /// provides the flat representation of the type signature, and the BCS of the corresponding
  /// data.
  public var contents: Contents? { __data["contents"] }
  public var address: MySoKit.MySoAddressApollo { __data["address"] }
  /// The estimated reward for this stake object, calculated as:
  ///
  /// principal * (initial_stake_rate / current_stake_rate - 1.0)
  ///
  /// Or 0, if this value is negative, where:
  ///
  /// - `initial_stake_rate` is the stake rate at the epoch this stake was activated at.
  /// - `current_stake_rate` is the stake rate in the current epoch.
  ///
  /// This value is only available if the stake is active.
  public var estimatedReward: MySoKit.BigIntApollo? { __data["estimatedReward"] }

  /// ActivatedEpoch
  ///
  /// Parent Type: `Epoch`
  public struct ActivatedEpoch: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Epoch }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("epochId", MySoKit.UInt53Apollo.self),
      .field("referenceGasPrice", MySoKit.BigIntApollo?.self)
    ] }

    /// The epoch's id as a sequence number that starts at 0 and is incremented by one at every epoch change.
    public var epochId: MySoKit.UInt53Apollo { __data["epochId"] }
    /// The minimum gas price that a quorum of validators are guaranteed to sign a transaction for.
    public var referenceGasPrice: MySoKit.BigIntApollo? { __data["referenceGasPrice"] }
  }

  /// RequestedEpoch
  ///
  /// Parent Type: `Epoch`
  public struct RequestedEpoch: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.Epoch }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("epochId", MySoKit.UInt53Apollo.self)
    ] }

    /// The epoch's id as a sequence number that starts at 0 and is incremented by one at every epoch change.
    public var epochId: MySoKit.UInt53Apollo { __data["epochId"] }
  }

  /// Contents
  ///
  /// Parent Type: `MoveValue`
  public struct Contents: MySoKit.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MySoKit.Objects.MoveValue }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("json", MySoKit.JSONApollo.self)
    ] }

    /// Representation of a Move value in JSON, where:
    ///
    /// - Addresses, IDs, and UIDs are represented in canonical form, as JSON strings.
    /// - Bools are represented by JSON boolean literals.
    /// - u8, u16, and u32 are represented as JSON numbers.
    /// - u64, u128, and u256 are represented as JSON strings.
    /// - Vectors are represented by JSON arrays.
    /// - Structs are represented by JSON objects.
    /// - Empty optional values are represented by `null`.
    ///
    /// This form is offered as a less verbose convenience in cases where the layout of the type is
    /// known by the client.
    public var json: MySoKit.JSONApollo { __data["json"] }
  }
}

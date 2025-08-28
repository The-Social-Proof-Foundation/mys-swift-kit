// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == MySoKit.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == MySoKit.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == MySoKit.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == MySoKit.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Address": return MySoKit.Objects.Address
    case "AddressOwner": return MySoKit.Objects.AddressOwner
    case "AuthenticatorStateCreateTransaction": return MySoKit.Objects.AuthenticatorStateCreateTransaction
    case "AuthenticatorStateExpireTransaction": return MySoKit.Objects.AuthenticatorStateExpireTransaction
    case "AuthenticatorStateUpdateTransaction": return MySoKit.Objects.AuthenticatorStateUpdateTransaction
    case "Balance": return MySoKit.Objects.Balance
    case "BalanceChange": return MySoKit.Objects.BalanceChange
    case "BalanceChangeConnection": return MySoKit.Objects.BalanceChangeConnection
    case "BalanceConnection": return MySoKit.Objects.BalanceConnection
    case "BridgeCommitteeInitTransaction": return MySoKit.Objects.BridgeCommitteeInitTransaction
    case "BridgeStateCreateTransaction": return MySoKit.Objects.BridgeStateCreateTransaction
    case "ChangeEpochTransaction": return MySoKit.Objects.ChangeEpochTransaction
    case "Checkpoint": return MySoKit.Objects.Checkpoint
    case "CheckpointConnection": return MySoKit.Objects.CheckpointConnection
    case "Coin": return MySoKit.Objects.Coin
    case "CoinConnection": return MySoKit.Objects.CoinConnection
    case "CoinDenyListStateCreateTransaction": return MySoKit.Objects.CoinDenyListStateCreateTransaction
    case "CoinMetadata": return MySoKit.Objects.CoinMetadata
    case "ConsensusCommitPrologueTransaction": return MySoKit.Objects.ConsensusCommitPrologueTransaction
    case "ConsensusV2": return MySoKit.Objects.ConsensusV2
    case "DisplayEntry": return MySoKit.Objects.DisplayEntry
    case "DryRunEffect": return MySoKit.Objects.DryRunEffect
    case "DryRunMutation": return MySoKit.Objects.DryRunMutation
    case "DryRunResult": return MySoKit.Objects.DryRunResult
    case "DryRunReturn": return MySoKit.Objects.DryRunReturn
    case "DynamicField": return MySoKit.Objects.DynamicField
    case "DynamicFieldConnection": return MySoKit.Objects.DynamicFieldConnection
    case "EndOfEpochTransaction": return MySoKit.Objects.EndOfEpochTransaction
    case "EndOfEpochTransactionKindConnection": return MySoKit.Objects.EndOfEpochTransactionKindConnection
    case "Epoch": return MySoKit.Objects.Epoch
    case "Event": return MySoKit.Objects.Event
    case "EventConnection": return MySoKit.Objects.EventConnection
    case "ExecutionResult": return MySoKit.Objects.ExecutionResult
    case "GasCoin": return MySoKit.Objects.GasCoin
    case "GasCostSummary": return MySoKit.Objects.GasCostSummary
    case "GenesisTransaction": return MySoKit.Objects.GenesisTransaction
    case "Immutable": return MySoKit.Objects.Immutable
    case "Input": return MySoKit.Objects.Input
    case "MoveDatatype": return MySoKit.Objects.MoveDatatype
    case "MoveEnum": return MySoKit.Objects.MoveEnum
    case "MoveEnumConnection": return MySoKit.Objects.MoveEnumConnection
    case "MoveEnumVariant": return MySoKit.Objects.MoveEnumVariant
    case "MoveField": return MySoKit.Objects.MoveField
    case "MoveFunction": return MySoKit.Objects.MoveFunction
    case "MoveFunctionConnection": return MySoKit.Objects.MoveFunctionConnection
    case "MoveFunctionTypeParameter": return MySoKit.Objects.MoveFunctionTypeParameter
    case "MoveModule": return MySoKit.Objects.MoveModule
    case "MoveModuleConnection": return MySoKit.Objects.MoveModuleConnection
    case "MoveObject": return MySoKit.Objects.MoveObject
    case "MoveObjectConnection": return MySoKit.Objects.MoveObjectConnection
    case "MovePackage": return MySoKit.Objects.MovePackage
    case "MoveStruct": return MySoKit.Objects.MoveStruct
    case "MoveStructConnection": return MySoKit.Objects.MoveStructConnection
    case "MoveStructTypeParameter": return MySoKit.Objects.MoveStructTypeParameter
    case "MoveType": return MySoKit.Objects.MoveType
    case "MoveValue": return MySoKit.Objects.MoveValue
    case "Mutation": return MySoKit.Objects.Mutation
    case "Object": return MySoKit.Objects.Object
    case "ObjectChange": return MySoKit.Objects.ObjectChange
    case "ObjectChangeConnection": return MySoKit.Objects.ObjectChangeConnection
    case "ObjectConnection": return MySoKit.Objects.ObjectConnection
    case "OpenMoveType": return MySoKit.Objects.OpenMoveType
    case "Owner": return MySoKit.Objects.Owner
    case "PageInfo": return MySoKit.Objects.PageInfo
    case "Parent": return MySoKit.Objects.Parent
    case "ProgrammableTransactionBlock": return MySoKit.Objects.ProgrammableTransactionBlock
    case "ProtocolConfigAttr": return MySoKit.Objects.ProtocolConfigAttr
    case "ProtocolConfigFeatureFlag": return MySoKit.Objects.ProtocolConfigFeatureFlag
    case "ProtocolConfigs": return MySoKit.Objects.ProtocolConfigs
    case "Query": return MySoKit.Objects.Query
    case "RandomnessStateCreateTransaction": return MySoKit.Objects.RandomnessStateCreateTransaction
    case "RandomnessStateUpdateTransaction": return MySoKit.Objects.RandomnessStateUpdateTransaction
    case "Result": return MySoKit.Objects.Result
    case "SafeMode": return MySoKit.Objects.SafeMode
    case "Shared": return MySoKit.Objects.Shared
    case "StakeSubsidy": return MySoKit.Objects.StakeSubsidy
    case "StakedMys": return MySoKit.Objects.StakedMySo
    case "StakedMysConnection": return MySoKit.Objects.StakedMySoConnection
    case "StorageFund": return MySoKit.Objects.StorageFund
    case "MysnsRegistration": return MySoKit.Objects.MySonsRegistration
    case "MysnsRegistrationConnection": return MySoKit.Objects.MySonsRegistrationConnection
    case "SystemParameters": return MySoKit.Objects.SystemParameters
    case "TransactionBlock": return MySoKit.Objects.TransactionBlock
    case "TransactionBlockConnection": return MySoKit.Objects.TransactionBlockConnection
    case "TransactionBlockEffects": return MySoKit.Objects.TransactionBlockEffects
    case "Validator": return MySoKit.Objects.Validator
    case "ValidatorConnection": return MySoKit.Objects.ValidatorConnection
    case "ValidatorCredentials": return MySoKit.Objects.ValidatorCredentials
    case "ValidatorSet": return MySoKit.Objects.ValidatorSet
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}

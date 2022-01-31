import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class OrderModel {
  int status;
  String message;
  DataOrder data;
  @JsonKey(ignore: true)
  dynamic error;

  OrderModel({
    this.status,
    this.data,
    this.message,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  OrderModel.withError(this.error);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class DataOrder {
  String id;
  String noTransaction;
  int total;
  PaymentMethod paymentMethod;

  DataOrder({
    this.id,
    this.noTransaction,
    this.total,
    this.paymentMethod,
  });

  factory DataOrder.fromJson(Map<String, dynamic> json) =>
      _$DataOrderFromJson(json);

  Map<String, dynamic> toJson() => _$DataOrderToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class PaymentMethod {
  String id;
  String paymentType;

  PaymentMethod({
    this.id,
    this.paymentType,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'set_light.dart';

class LightStatusMapper extends EnumMapper<LightStatus> {
  LightStatusMapper._();

  static LightStatusMapper? _instance;
  static LightStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LightStatusMapper._());
    }
    return _instance!;
  }

  static LightStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  LightStatus decode(dynamic value) {
    switch (value) {
      case 'off':
        return LightStatus.off;
      case 'on':
        return LightStatus.on;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(LightStatus self) {
    switch (self) {
      case LightStatus.off:
        return 'off';
      case LightStatus.on:
        return 'on';
    }
  }
}

extension LightStatusMapperExtension on LightStatus {
  String toValue() {
    LightStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<LightStatus>(this) as String;
  }
}

class SetLightDtoMapper extends ClassMapperBase<SetLightDto> {
  SetLightDtoMapper._();

  static SetLightDtoMapper? _instance;
  static SetLightDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SetLightDtoMapper._());
      LightStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SetLightDto';

  static int? _$brightness(SetLightDto v) => v.brightness;
  static const Field<SetLightDto, int> _f$brightness =
      Field('brightness', _$brightness);
  static LightStatus? _$status(SetLightDto v) => v.status;
  static const Field<SetLightDto, LightStatus> _f$status =
      Field('status', _$status);

  @override
  final MappableFields<SetLightDto> fields = const {
    #brightness: _f$brightness,
    #status: _f$status,
  };

  static SetLightDto _instantiate(DecodingData data) {
    return SetLightDto(
        brightness: data.dec(_f$brightness), status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static SetLightDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SetLightDto>(map);
  }

  static SetLightDto fromJson(String json) {
    return ensureInitialized().decodeJson<SetLightDto>(json);
  }
}

mixin SetLightDtoMappable {
  String toJson() {
    return SetLightDtoMapper.ensureInitialized()
        .encodeJson<SetLightDto>(this as SetLightDto);
  }

  Map<String, dynamic> toMap() {
    return SetLightDtoMapper.ensureInitialized()
        .encodeMap<SetLightDto>(this as SetLightDto);
  }

  SetLightDtoCopyWith<SetLightDto, SetLightDto, SetLightDto> get copyWith =>
      _SetLightDtoCopyWithImpl(this as SetLightDto, $identity, $identity);
  @override
  String toString() {
    return SetLightDtoMapper.ensureInitialized()
        .stringifyValue(this as SetLightDto);
  }

  @override
  bool operator ==(Object other) {
    return SetLightDtoMapper.ensureInitialized()
        .equalsValue(this as SetLightDto, other);
  }

  @override
  int get hashCode {
    return SetLightDtoMapper.ensureInitialized().hashValue(this as SetLightDto);
  }
}

extension SetLightDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SetLightDto, $Out> {
  SetLightDtoCopyWith<$R, SetLightDto, $Out> get $asSetLightDto =>
      $base.as((v, t, t2) => _SetLightDtoCopyWithImpl(v, t, t2));
}

abstract class SetLightDtoCopyWith<$R, $In extends SetLightDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? brightness, LightStatus? status});
  SetLightDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SetLightDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SetLightDto, $Out>
    implements SetLightDtoCopyWith<$R, SetLightDto, $Out> {
  _SetLightDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SetLightDto> $mapper =
      SetLightDtoMapper.ensureInitialized();
  @override
  $R call({Object? brightness = $none, Object? status = $none}) =>
      $apply(FieldCopyWithData({
        if (brightness != $none) #brightness: brightness,
        if (status != $none) #status: status
      }));
  @override
  SetLightDto $make(CopyWithData data) => SetLightDto(
      brightness: data.get(#brightness, or: $value.brightness),
      status: data.get(#status, or: $value.status));

  @override
  SetLightDtoCopyWith<$R2, SetLightDto, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SetLightDtoCopyWithImpl($value, $cast, t);
}

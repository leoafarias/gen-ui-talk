// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'control_light.dart';

class ControlLightDtoMapper extends ClassMapperBase<ControlLightDto> {
  ControlLightDtoMapper._();

  static ControlLightDtoMapper? _instance;
  static ControlLightDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ControlLightDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ControlLightDto';

  static int? _$brightness(ControlLightDto v) => v.brightness;
  static const Field<ControlLightDto, int> _f$brightness =
      Field('brightness', _$brightness);

  @override
  final MappableFields<ControlLightDto> fields = const {
    #brightness: _f$brightness,
  };

  static ControlLightDto _instantiate(DecodingData data) {
    return ControlLightDto(brightness: data.dec(_f$brightness));
  }

  @override
  final Function instantiate = _instantiate;

  static ControlLightDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ControlLightDto>(map);
  }

  static ControlLightDto fromJson(String json) {
    return ensureInitialized().decodeJson<ControlLightDto>(json);
  }
}

mixin ControlLightDtoMappable {
  String toJson() {
    return ControlLightDtoMapper.ensureInitialized()
        .encodeJson<ControlLightDto>(this as ControlLightDto);
  }

  Map<String, dynamic> toMap() {
    return ControlLightDtoMapper.ensureInitialized()
        .encodeMap<ControlLightDto>(this as ControlLightDto);
  }

  ControlLightDtoCopyWith<ControlLightDto, ControlLightDto, ControlLightDto>
      get copyWith => _ControlLightDtoCopyWithImpl(
          this as ControlLightDto, $identity, $identity);
  @override
  String toString() {
    return ControlLightDtoMapper.ensureInitialized()
        .stringifyValue(this as ControlLightDto);
  }

  @override
  bool operator ==(Object other) {
    return ControlLightDtoMapper.ensureInitialized()
        .equalsValue(this as ControlLightDto, other);
  }

  @override
  int get hashCode {
    return ControlLightDtoMapper.ensureInitialized()
        .hashValue(this as ControlLightDto);
  }
}

extension ControlLightDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ControlLightDto, $Out> {
  ControlLightDtoCopyWith<$R, ControlLightDto, $Out> get $asControlLightDto =>
      $base.as((v, t, t2) => _ControlLightDtoCopyWithImpl(v, t, t2));
}

abstract class ControlLightDtoCopyWith<$R, $In extends ControlLightDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? brightness});
  ControlLightDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ControlLightDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ControlLightDto, $Out>
    implements ControlLightDtoCopyWith<$R, ControlLightDto, $Out> {
  _ControlLightDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ControlLightDto> $mapper =
      ControlLightDtoMapper.ensureInitialized();
  @override
  $R call({Object? brightness = $none}) => $apply(
      FieldCopyWithData({if (brightness != $none) #brightness: brightness}));
  @override
  ControlLightDto $make(CopyWithData data) =>
      ControlLightDto(brightness: data.get(#brightness, or: $value.brightness));

  @override
  ControlLightDtoCopyWith<$R2, ControlLightDto, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ControlLightDtoCopyWithImpl($value, $cast, t);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CoursesTable extends Courses with TableInfo<$CoursesTable, CursoFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoursesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _docenteMeta = const VerificationMeta(
    'docente',
  );
  @override
  late final GeneratedColumn<String> docente = GeneratedColumn<String>(
    'docente',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> dias =
      GeneratedColumn<String>(
        'dias',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      ).withConverter<List<String>>($CoursesTable.$converterdias);
  static const VerificationMeta _horaInicioMeta = const VerificationMeta(
    'horaInicio',
  );
  @override
  late final GeneratedColumn<String> horaInicio = GeneratedColumn<String>(
    'hora_inicio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _horaFinMeta = const VerificationMeta(
    'horaFin',
  );
  @override
  late final GeneratedColumn<String> horaFin = GeneratedColumn<String>(
    'hora_fin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _periodoMeta = const VerificationMeta(
    'periodo',
  );
  @override
  late final GeneratedColumn<String> periodo = GeneratedColumn<String>(
    'periodo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('2026-2'),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    docente,
    color,
    dias,
    horaInicio,
    horaFin,
    periodo,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courses';
  @override
  VerificationContext validateIntegrity(
    Insertable<CursoFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('docente')) {
      context.handle(
        _docenteMeta,
        docente.isAcceptableOrUnknown(data['docente']!, _docenteMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('hora_inicio')) {
      context.handle(
        _horaInicioMeta,
        horaInicio.isAcceptableOrUnknown(data['hora_inicio']!, _horaInicioMeta),
      );
    }
    if (data.containsKey('hora_fin')) {
      context.handle(
        _horaFinMeta,
        horaFin.isAcceptableOrUnknown(data['hora_fin']!, _horaFinMeta),
      );
    }
    if (data.containsKey('periodo')) {
      context.handle(
        _periodoMeta,
        periodo.isAcceptableOrUnknown(data['periodo']!, _periodoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CursoFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CursoFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      docente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}docente'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      dias: $CoursesTable.$converterdias.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}dias'],
        )!,
      ),
      horaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hora_inicio'],
      )!,
      horaFin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hora_fin'],
      )!,
      periodo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}periodo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $CoursesTable createAlias(String alias) {
    return $CoursesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterdias =
      const DiasConverter();
}

class CursoFila extends DataClass implements Insertable<CursoFila> {
  final String id;
  final String nombre;
  final String docente;

  /// Color en formato ARGB de 32 bits.
  final int color;
  final List<String> dias;
  final String horaInicio;
  final String horaFin;
  final String periodo;
  final DateTime creadoEn;
  const CursoFila({
    required this.id,
    required this.nombre,
    required this.docente,
    required this.color,
    required this.dias,
    required this.horaInicio,
    required this.horaFin,
    required this.periodo,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['docente'] = Variable<String>(docente);
    map['color'] = Variable<int>(color);
    {
      map['dias'] = Variable<String>($CoursesTable.$converterdias.toSql(dias));
    }
    map['hora_inicio'] = Variable<String>(horaInicio);
    map['hora_fin'] = Variable<String>(horaFin);
    map['periodo'] = Variable<String>(periodo);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  CoursesCompanion toCompanion(bool nullToAbsent) {
    return CoursesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      docente: Value(docente),
      color: Value(color),
      dias: Value(dias),
      horaInicio: Value(horaInicio),
      horaFin: Value(horaFin),
      periodo: Value(periodo),
      creadoEn: Value(creadoEn),
    );
  }

  factory CursoFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CursoFila(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      docente: serializer.fromJson<String>(json['docente']),
      color: serializer.fromJson<int>(json['color']),
      dias: serializer.fromJson<List<String>>(json['dias']),
      horaInicio: serializer.fromJson<String>(json['horaInicio']),
      horaFin: serializer.fromJson<String>(json['horaFin']),
      periodo: serializer.fromJson<String>(json['periodo']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'docente': serializer.toJson<String>(docente),
      'color': serializer.toJson<int>(color),
      'dias': serializer.toJson<List<String>>(dias),
      'horaInicio': serializer.toJson<String>(horaInicio),
      'horaFin': serializer.toJson<String>(horaFin),
      'periodo': serializer.toJson<String>(periodo),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  CursoFila copyWith({
    String? id,
    String? nombre,
    String? docente,
    int? color,
    List<String>? dias,
    String? horaInicio,
    String? horaFin,
    String? periodo,
    DateTime? creadoEn,
  }) => CursoFila(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    docente: docente ?? this.docente,
    color: color ?? this.color,
    dias: dias ?? this.dias,
    horaInicio: horaInicio ?? this.horaInicio,
    horaFin: horaFin ?? this.horaFin,
    periodo: periodo ?? this.periodo,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  CursoFila copyWithCompanion(CoursesCompanion data) {
    return CursoFila(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      docente: data.docente.present ? data.docente.value : this.docente,
      color: data.color.present ? data.color.value : this.color,
      dias: data.dias.present ? data.dias.value : this.dias,
      horaInicio: data.horaInicio.present
          ? data.horaInicio.value
          : this.horaInicio,
      horaFin: data.horaFin.present ? data.horaFin.value : this.horaFin,
      periodo: data.periodo.present ? data.periodo.value : this.periodo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CursoFila(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('docente: $docente, ')
          ..write('color: $color, ')
          ..write('dias: $dias, ')
          ..write('horaInicio: $horaInicio, ')
          ..write('horaFin: $horaFin, ')
          ..write('periodo: $periodo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    docente,
    color,
    dias,
    horaInicio,
    horaFin,
    periodo,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CursoFila &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.docente == this.docente &&
          other.color == this.color &&
          other.dias == this.dias &&
          other.horaInicio == this.horaInicio &&
          other.horaFin == this.horaFin &&
          other.periodo == this.periodo &&
          other.creadoEn == this.creadoEn);
}

class CoursesCompanion extends UpdateCompanion<CursoFila> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String> docente;
  final Value<int> color;
  final Value<List<String>> dias;
  final Value<String> horaInicio;
  final Value<String> horaFin;
  final Value<String> periodo;
  final Value<DateTime> creadoEn;
  final Value<int> rowid;
  const CoursesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.docente = const Value.absent(),
    this.color = const Value.absent(),
    this.dias = const Value.absent(),
    this.horaInicio = const Value.absent(),
    this.horaFin = const Value.absent(),
    this.periodo = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoursesCompanion.insert({
    required String id,
    required String nombre,
    this.docente = const Value.absent(),
    required int color,
    this.dias = const Value.absent(),
    this.horaInicio = const Value.absent(),
    this.horaFin = const Value.absent(),
    this.periodo = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nombre = Value(nombre),
       color = Value(color);
  static Insertable<CursoFila> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? docente,
    Expression<int>? color,
    Expression<String>? dias,
    Expression<String>? horaInicio,
    Expression<String>? horaFin,
    Expression<String>? periodo,
    Expression<DateTime>? creadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (docente != null) 'docente': docente,
      if (color != null) 'color': color,
      if (dias != null) 'dias': dias,
      if (horaInicio != null) 'hora_inicio': horaInicio,
      if (horaFin != null) 'hora_fin': horaFin,
      if (periodo != null) 'periodo': periodo,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoursesCompanion copyWith({
    Value<String>? id,
    Value<String>? nombre,
    Value<String>? docente,
    Value<int>? color,
    Value<List<String>>? dias,
    Value<String>? horaInicio,
    Value<String>? horaFin,
    Value<String>? periodo,
    Value<DateTime>? creadoEn,
    Value<int>? rowid,
  }) {
    return CoursesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      docente: docente ?? this.docente,
      color: color ?? this.color,
      dias: dias ?? this.dias,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      periodo: periodo ?? this.periodo,
      creadoEn: creadoEn ?? this.creadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (docente.present) {
      map['docente'] = Variable<String>(docente.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (dias.present) {
      map['dias'] = Variable<String>(
        $CoursesTable.$converterdias.toSql(dias.value),
      );
    }
    if (horaInicio.present) {
      map['hora_inicio'] = Variable<String>(horaInicio.value);
    }
    if (horaFin.present) {
      map['hora_fin'] = Variable<String>(horaFin.value);
    }
    if (periodo.present) {
      map['periodo'] = Variable<String>(periodo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoursesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('docente: $docente, ')
          ..write('color: $color, ')
          ..write('dias: $dias, ')
          ..write('horaInicio: $horaInicio, ')
          ..write('horaFin: $horaFin, ')
          ..write('periodo: $periodo, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TareaFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cursoIdMeta = const VerificationMeta(
    'cursoId',
  );
  @override
  late final GeneratedColumn<String> cursoId = GeneratedColumn<String>(
    'curso_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES courses (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoTarea, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoTarea>($TasksTable.$convertertipo);
  @override
  late final GeneratedColumnWithTypeConverter<Prioridad, String> prioridad =
      GeneratedColumn<String>(
        'prioridad',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Prioridad>($TasksTable.$converterprioridad);
  @override
  late final GeneratedColumnWithTypeConverter<EstadoTarea, String> estado =
      GeneratedColumn<String>(
        'estado',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EstadoTarea>($TasksTable.$converterestado);
  static const VerificationMeta _fechaEntregaMeta = const VerificationMeta(
    'fechaEntrega',
  );
  @override
  late final GeneratedColumn<DateTime> fechaEntrega = GeneratedColumn<DateTime>(
    'fecha_entrega',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creadaEnMeta = const VerificationMeta(
    'creadaEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadaEn = GeneratedColumn<DateTime>(
    'creada_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _actualizadaEnMeta = const VerificationMeta(
    'actualizadaEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadaEn =
      GeneratedColumn<DateTime>(
        'actualizada_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cursoId,
    titulo,
    descripcion,
    tipo,
    prioridad,
    estado,
    fechaEntrega,
    creadaEn,
    actualizadaEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TareaFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('curso_id')) {
      context.handle(
        _cursoIdMeta,
        cursoId.isAcceptableOrUnknown(data['curso_id']!, _cursoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cursoIdMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('fecha_entrega')) {
      context.handle(
        _fechaEntregaMeta,
        fechaEntrega.isAcceptableOrUnknown(
          data['fecha_entrega']!,
          _fechaEntregaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaEntregaMeta);
    }
    if (data.containsKey('creada_en')) {
      context.handle(
        _creadaEnMeta,
        creadaEn.isAcceptableOrUnknown(data['creada_en']!, _creadaEnMeta),
      );
    }
    if (data.containsKey('actualizada_en')) {
      context.handle(
        _actualizadaEnMeta,
        actualizadaEn.isAcceptableOrUnknown(
          data['actualizada_en']!,
          _actualizadaEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TareaFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TareaFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cursoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}curso_id'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      tipo: $TasksTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      prioridad: $TasksTable.$converterprioridad.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}prioridad'],
        )!,
      ),
      estado: $TasksTable.$converterestado.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}estado'],
        )!,
      ),
      fechaEntrega: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_entrega'],
      )!,
      creadaEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creada_en'],
      )!,
      actualizadaEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizada_en'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoTarea, String, String> $convertertipo =
      const EnumNameConverter<TipoTarea>(TipoTarea.values);
  static JsonTypeConverter2<Prioridad, String, String> $converterprioridad =
      const EnumNameConverter<Prioridad>(Prioridad.values);
  static JsonTypeConverter2<EstadoTarea, String, String> $converterestado =
      const EnumNameConverter<EstadoTarea>(EstadoTarea.values);
}

class TareaFila extends DataClass implements Insertable<TareaFila> {
  final String id;

  /// RESTRICT: la base no deja borrar un curso que todavía tiene tareas.
  /// La regla también se revisa en el repositorio para dar un mensaje claro.
  final String cursoId;
  final String titulo;
  final String descripcion;
  final TipoTarea tipo;
  final Prioridad prioridad;
  final EstadoTarea estado;
  final DateTime fechaEntrega;
  final DateTime creadaEn;
  final DateTime actualizadaEn;
  const TareaFila({
    required this.id,
    required this.cursoId,
    required this.titulo,
    required this.descripcion,
    required this.tipo,
    required this.prioridad,
    required this.estado,
    required this.fechaEntrega,
    required this.creadaEn,
    required this.actualizadaEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['curso_id'] = Variable<String>(cursoId);
    map['titulo'] = Variable<String>(titulo);
    map['descripcion'] = Variable<String>(descripcion);
    {
      map['tipo'] = Variable<String>($TasksTable.$convertertipo.toSql(tipo));
    }
    {
      map['prioridad'] = Variable<String>(
        $TasksTable.$converterprioridad.toSql(prioridad),
      );
    }
    {
      map['estado'] = Variable<String>(
        $TasksTable.$converterestado.toSql(estado),
      );
    }
    map['fecha_entrega'] = Variable<DateTime>(fechaEntrega);
    map['creada_en'] = Variable<DateTime>(creadaEn);
    map['actualizada_en'] = Variable<DateTime>(actualizadaEn);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      cursoId: Value(cursoId),
      titulo: Value(titulo),
      descripcion: Value(descripcion),
      tipo: Value(tipo),
      prioridad: Value(prioridad),
      estado: Value(estado),
      fechaEntrega: Value(fechaEntrega),
      creadaEn: Value(creadaEn),
      actualizadaEn: Value(actualizadaEn),
    );
  }

  factory TareaFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TareaFila(
      id: serializer.fromJson<String>(json['id']),
      cursoId: serializer.fromJson<String>(json['cursoId']),
      titulo: serializer.fromJson<String>(json['titulo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      tipo: $TasksTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      prioridad: $TasksTable.$converterprioridad.fromJson(
        serializer.fromJson<String>(json['prioridad']),
      ),
      estado: $TasksTable.$converterestado.fromJson(
        serializer.fromJson<String>(json['estado']),
      ),
      fechaEntrega: serializer.fromJson<DateTime>(json['fechaEntrega']),
      creadaEn: serializer.fromJson<DateTime>(json['creadaEn']),
      actualizadaEn: serializer.fromJson<DateTime>(json['actualizadaEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cursoId': serializer.toJson<String>(cursoId),
      'titulo': serializer.toJson<String>(titulo),
      'descripcion': serializer.toJson<String>(descripcion),
      'tipo': serializer.toJson<String>(
        $TasksTable.$convertertipo.toJson(tipo),
      ),
      'prioridad': serializer.toJson<String>(
        $TasksTable.$converterprioridad.toJson(prioridad),
      ),
      'estado': serializer.toJson<String>(
        $TasksTable.$converterestado.toJson(estado),
      ),
      'fechaEntrega': serializer.toJson<DateTime>(fechaEntrega),
      'creadaEn': serializer.toJson<DateTime>(creadaEn),
      'actualizadaEn': serializer.toJson<DateTime>(actualizadaEn),
    };
  }

  TareaFila copyWith({
    String? id,
    String? cursoId,
    String? titulo,
    String? descripcion,
    TipoTarea? tipo,
    Prioridad? prioridad,
    EstadoTarea? estado,
    DateTime? fechaEntrega,
    DateTime? creadaEn,
    DateTime? actualizadaEn,
  }) => TareaFila(
    id: id ?? this.id,
    cursoId: cursoId ?? this.cursoId,
    titulo: titulo ?? this.titulo,
    descripcion: descripcion ?? this.descripcion,
    tipo: tipo ?? this.tipo,
    prioridad: prioridad ?? this.prioridad,
    estado: estado ?? this.estado,
    fechaEntrega: fechaEntrega ?? this.fechaEntrega,
    creadaEn: creadaEn ?? this.creadaEn,
    actualizadaEn: actualizadaEn ?? this.actualizadaEn,
  );
  TareaFila copyWithCompanion(TasksCompanion data) {
    return TareaFila(
      id: data.id.present ? data.id.value : this.id,
      cursoId: data.cursoId.present ? data.cursoId.value : this.cursoId,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      prioridad: data.prioridad.present ? data.prioridad.value : this.prioridad,
      estado: data.estado.present ? data.estado.value : this.estado,
      fechaEntrega: data.fechaEntrega.present
          ? data.fechaEntrega.value
          : this.fechaEntrega,
      creadaEn: data.creadaEn.present ? data.creadaEn.value : this.creadaEn,
      actualizadaEn: data.actualizadaEn.present
          ? data.actualizadaEn.value
          : this.actualizadaEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TareaFila(')
          ..write('id: $id, ')
          ..write('cursoId: $cursoId, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipo: $tipo, ')
          ..write('prioridad: $prioridad, ')
          ..write('estado: $estado, ')
          ..write('fechaEntrega: $fechaEntrega, ')
          ..write('creadaEn: $creadaEn, ')
          ..write('actualizadaEn: $actualizadaEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cursoId,
    titulo,
    descripcion,
    tipo,
    prioridad,
    estado,
    fechaEntrega,
    creadaEn,
    actualizadaEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TareaFila &&
          other.id == this.id &&
          other.cursoId == this.cursoId &&
          other.titulo == this.titulo &&
          other.descripcion == this.descripcion &&
          other.tipo == this.tipo &&
          other.prioridad == this.prioridad &&
          other.estado == this.estado &&
          other.fechaEntrega == this.fechaEntrega &&
          other.creadaEn == this.creadaEn &&
          other.actualizadaEn == this.actualizadaEn);
}

class TasksCompanion extends UpdateCompanion<TareaFila> {
  final Value<String> id;
  final Value<String> cursoId;
  final Value<String> titulo;
  final Value<String> descripcion;
  final Value<TipoTarea> tipo;
  final Value<Prioridad> prioridad;
  final Value<EstadoTarea> estado;
  final Value<DateTime> fechaEntrega;
  final Value<DateTime> creadaEn;
  final Value<DateTime> actualizadaEn;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.cursoId = const Value.absent(),
    this.titulo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.tipo = const Value.absent(),
    this.prioridad = const Value.absent(),
    this.estado = const Value.absent(),
    this.fechaEntrega = const Value.absent(),
    this.creadaEn = const Value.absent(),
    this.actualizadaEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String cursoId,
    required String titulo,
    this.descripcion = const Value.absent(),
    required TipoTarea tipo,
    required Prioridad prioridad,
    required EstadoTarea estado,
    required DateTime fechaEntrega,
    this.creadaEn = const Value.absent(),
    this.actualizadaEn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cursoId = Value(cursoId),
       titulo = Value(titulo),
       tipo = Value(tipo),
       prioridad = Value(prioridad),
       estado = Value(estado),
       fechaEntrega = Value(fechaEntrega);
  static Insertable<TareaFila> custom({
    Expression<String>? id,
    Expression<String>? cursoId,
    Expression<String>? titulo,
    Expression<String>? descripcion,
    Expression<String>? tipo,
    Expression<String>? prioridad,
    Expression<String>? estado,
    Expression<DateTime>? fechaEntrega,
    Expression<DateTime>? creadaEn,
    Expression<DateTime>? actualizadaEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cursoId != null) 'curso_id': cursoId,
      if (titulo != null) 'titulo': titulo,
      if (descripcion != null) 'descripcion': descripcion,
      if (tipo != null) 'tipo': tipo,
      if (prioridad != null) 'prioridad': prioridad,
      if (estado != null) 'estado': estado,
      if (fechaEntrega != null) 'fecha_entrega': fechaEntrega,
      if (creadaEn != null) 'creada_en': creadaEn,
      if (actualizadaEn != null) 'actualizada_en': actualizadaEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? cursoId,
    Value<String>? titulo,
    Value<String>? descripcion,
    Value<TipoTarea>? tipo,
    Value<Prioridad>? prioridad,
    Value<EstadoTarea>? estado,
    Value<DateTime>? fechaEntrega,
    Value<DateTime>? creadaEn,
    Value<DateTime>? actualizadaEn,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      cursoId: cursoId ?? this.cursoId,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      prioridad: prioridad ?? this.prioridad,
      estado: estado ?? this.estado,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      creadaEn: creadaEn ?? this.creadaEn,
      actualizadaEn: actualizadaEn ?? this.actualizadaEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cursoId.present) {
      map['curso_id'] = Variable<String>(cursoId.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $TasksTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (prioridad.present) {
      map['prioridad'] = Variable<String>(
        $TasksTable.$converterprioridad.toSql(prioridad.value),
      );
    }
    if (estado.present) {
      map['estado'] = Variable<String>(
        $TasksTable.$converterestado.toSql(estado.value),
      );
    }
    if (fechaEntrega.present) {
      map['fecha_entrega'] = Variable<DateTime>(fechaEntrega.value);
    }
    if (creadaEn.present) {
      map['creada_en'] = Variable<DateTime>(creadaEn.value);
    }
    if (actualizadaEn.present) {
      map['actualizada_en'] = Variable<DateTime>(actualizadaEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('cursoId: $cursoId, ')
          ..write('titulo: $titulo, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipo: $tipo, ')
          ..write('prioridad: $prioridad, ')
          ..write('estado: $estado, ')
          ..write('fechaEntrega: $fechaEntrega, ')
          ..write('creadaEn: $creadaEn, ')
          ..write('actualizadaEn: $actualizadaEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubtasksTable extends Subtasks
    with TableInfo<$SubtasksTable, SubtareaFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tareaIdMeta = const VerificationMeta(
    'tareaId',
  );
  @override
  late final GeneratedColumn<String> tareaId = GeneratedColumn<String>(
    'tarea_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hechaMeta = const VerificationMeta('hecha');
  @override
  late final GeneratedColumn<bool> hecha = GeneratedColumn<bool>(
    'hecha',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("hecha" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _posicionMeta = const VerificationMeta(
    'posicion',
  );
  @override
  late final GeneratedColumn<int> posicion = GeneratedColumn<int>(
    'posicion',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, tareaId, titulo, hecha, posicion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubtareaFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tarea_id')) {
      context.handle(
        _tareaIdMeta,
        tareaId.isAcceptableOrUnknown(data['tarea_id']!, _tareaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tareaIdMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('hecha')) {
      context.handle(
        _hechaMeta,
        hecha.isAcceptableOrUnknown(data['hecha']!, _hechaMeta),
      );
    }
    if (data.containsKey('posicion')) {
      context.handle(
        _posicionMeta,
        posicion.isAcceptableOrUnknown(data['posicion']!, _posicionMeta),
      );
    } else if (isInserting) {
      context.missing(_posicionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubtareaFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubtareaFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tareaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tarea_id'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      hecha: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hecha'],
      )!,
      posicion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}posicion'],
      )!,
    );
  }

  @override
  $SubtasksTable createAlias(String alias) {
    return $SubtasksTable(attachedDatabase, alias);
  }
}

class SubtareaFila extends DataClass implements Insertable<SubtareaFila> {
  final String id;
  final String tareaId;
  final String titulo;
  final bool hecha;

  /// Orden dentro de la lista de verificación.
  final int posicion;
  const SubtareaFila({
    required this.id,
    required this.tareaId,
    required this.titulo,
    required this.hecha,
    required this.posicion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tarea_id'] = Variable<String>(tareaId);
    map['titulo'] = Variable<String>(titulo);
    map['hecha'] = Variable<bool>(hecha);
    map['posicion'] = Variable<int>(posicion);
    return map;
  }

  SubtasksCompanion toCompanion(bool nullToAbsent) {
    return SubtasksCompanion(
      id: Value(id),
      tareaId: Value(tareaId),
      titulo: Value(titulo),
      hecha: Value(hecha),
      posicion: Value(posicion),
    );
  }

  factory SubtareaFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubtareaFila(
      id: serializer.fromJson<String>(json['id']),
      tareaId: serializer.fromJson<String>(json['tareaId']),
      titulo: serializer.fromJson<String>(json['titulo']),
      hecha: serializer.fromJson<bool>(json['hecha']),
      posicion: serializer.fromJson<int>(json['posicion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tareaId': serializer.toJson<String>(tareaId),
      'titulo': serializer.toJson<String>(titulo),
      'hecha': serializer.toJson<bool>(hecha),
      'posicion': serializer.toJson<int>(posicion),
    };
  }

  SubtareaFila copyWith({
    String? id,
    String? tareaId,
    String? titulo,
    bool? hecha,
    int? posicion,
  }) => SubtareaFila(
    id: id ?? this.id,
    tareaId: tareaId ?? this.tareaId,
    titulo: titulo ?? this.titulo,
    hecha: hecha ?? this.hecha,
    posicion: posicion ?? this.posicion,
  );
  SubtareaFila copyWithCompanion(SubtasksCompanion data) {
    return SubtareaFila(
      id: data.id.present ? data.id.value : this.id,
      tareaId: data.tareaId.present ? data.tareaId.value : this.tareaId,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      hecha: data.hecha.present ? data.hecha.value : this.hecha,
      posicion: data.posicion.present ? data.posicion.value : this.posicion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubtareaFila(')
          ..write('id: $id, ')
          ..write('tareaId: $tareaId, ')
          ..write('titulo: $titulo, ')
          ..write('hecha: $hecha, ')
          ..write('posicion: $posicion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tareaId, titulo, hecha, posicion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubtareaFila &&
          other.id == this.id &&
          other.tareaId == this.tareaId &&
          other.titulo == this.titulo &&
          other.hecha == this.hecha &&
          other.posicion == this.posicion);
}

class SubtasksCompanion extends UpdateCompanion<SubtareaFila> {
  final Value<String> id;
  final Value<String> tareaId;
  final Value<String> titulo;
  final Value<bool> hecha;
  final Value<int> posicion;
  final Value<int> rowid;
  const SubtasksCompanion({
    this.id = const Value.absent(),
    this.tareaId = const Value.absent(),
    this.titulo = const Value.absent(),
    this.hecha = const Value.absent(),
    this.posicion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubtasksCompanion.insert({
    required String id,
    required String tareaId,
    required String titulo,
    this.hecha = const Value.absent(),
    required int posicion,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tareaId = Value(tareaId),
       titulo = Value(titulo),
       posicion = Value(posicion);
  static Insertable<SubtareaFila> custom({
    Expression<String>? id,
    Expression<String>? tareaId,
    Expression<String>? titulo,
    Expression<bool>? hecha,
    Expression<int>? posicion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tareaId != null) 'tarea_id': tareaId,
      if (titulo != null) 'titulo': titulo,
      if (hecha != null) 'hecha': hecha,
      if (posicion != null) 'posicion': posicion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubtasksCompanion copyWith({
    Value<String>? id,
    Value<String>? tareaId,
    Value<String>? titulo,
    Value<bool>? hecha,
    Value<int>? posicion,
    Value<int>? rowid,
  }) {
    return SubtasksCompanion(
      id: id ?? this.id,
      tareaId: tareaId ?? this.tareaId,
      titulo: titulo ?? this.titulo,
      hecha: hecha ?? this.hecha,
      posicion: posicion ?? this.posicion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tareaId.present) {
      map['tarea_id'] = Variable<String>(tareaId.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (hecha.present) {
      map['hecha'] = Variable<bool>(hecha.value);
    }
    if (posicion.present) {
      map['posicion'] = Variable<int>(posicion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtasksCompanion(')
          ..write('id: $id, ')
          ..write('tareaId: $tareaId, ')
          ..write('titulo: $titulo, ')
          ..write('hecha: $hecha, ')
          ..write('posicion: $posicion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, RecordatorioFila> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tareaIdMeta = const VerificationMeta(
    'tareaId',
  );
  @override
  late final GeneratedColumn<String> tareaId = GeneratedColumn<String>(
    'tarea_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _minutosAntesMeta = const VerificationMeta(
    'minutosAntes',
  );
  @override
  late final GeneratedColumn<int> minutosAntes = GeneratedColumn<int>(
    'minutos_antes',
    aliasedName,
    false,
    check: () => ComparableExpr(minutosAntes).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, tareaId, minutosAntes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecordatorioFila> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tarea_id')) {
      context.handle(
        _tareaIdMeta,
        tareaId.isAcceptableOrUnknown(data['tarea_id']!, _tareaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tareaIdMeta);
    }
    if (data.containsKey('minutos_antes')) {
      context.handle(
        _minutosAntesMeta,
        minutosAntes.isAcceptableOrUnknown(
          data['minutos_antes']!,
          _minutosAntesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minutosAntesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecordatorioFila map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordatorioFila(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tareaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tarea_id'],
      )!,
      minutosAntes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutos_antes'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class RecordatorioFila extends DataClass
    implements Insertable<RecordatorioFila> {
  final int id;
  final String tareaId;
  final int minutosAntes;
  const RecordatorioFila({
    required this.id,
    required this.tareaId,
    required this.minutosAntes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tarea_id'] = Variable<String>(tareaId);
    map['minutos_antes'] = Variable<int>(minutosAntes);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      tareaId: Value(tareaId),
      minutosAntes: Value(minutosAntes),
    );
  }

  factory RecordatorioFila.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordatorioFila(
      id: serializer.fromJson<int>(json['id']),
      tareaId: serializer.fromJson<String>(json['tareaId']),
      minutosAntes: serializer.fromJson<int>(json['minutosAntes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tareaId': serializer.toJson<String>(tareaId),
      'minutosAntes': serializer.toJson<int>(minutosAntes),
    };
  }

  RecordatorioFila copyWith({int? id, String? tareaId, int? minutosAntes}) =>
      RecordatorioFila(
        id: id ?? this.id,
        tareaId: tareaId ?? this.tareaId,
        minutosAntes: minutosAntes ?? this.minutosAntes,
      );
  RecordatorioFila copyWithCompanion(RemindersCompanion data) {
    return RecordatorioFila(
      id: data.id.present ? data.id.value : this.id,
      tareaId: data.tareaId.present ? data.tareaId.value : this.tareaId,
      minutosAntes: data.minutosAntes.present
          ? data.minutosAntes.value
          : this.minutosAntes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordatorioFila(')
          ..write('id: $id, ')
          ..write('tareaId: $tareaId, ')
          ..write('minutosAntes: $minutosAntes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tareaId, minutosAntes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordatorioFila &&
          other.id == this.id &&
          other.tareaId == this.tareaId &&
          other.minutosAntes == this.minutosAntes);
}

class RemindersCompanion extends UpdateCompanion<RecordatorioFila> {
  final Value<int> id;
  final Value<String> tareaId;
  final Value<int> minutosAntes;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.tareaId = const Value.absent(),
    this.minutosAntes = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required String tareaId,
    required int minutosAntes,
  }) : tareaId = Value(tareaId),
       minutosAntes = Value(minutosAntes);
  static Insertable<RecordatorioFila> custom({
    Expression<int>? id,
    Expression<String>? tareaId,
    Expression<int>? minutosAntes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tareaId != null) 'tarea_id': tareaId,
      if (minutosAntes != null) 'minutos_antes': minutosAntes,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<String>? tareaId,
    Value<int>? minutosAntes,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      tareaId: tareaId ?? this.tareaId,
      minutosAntes: minutosAntes ?? this.minutosAntes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tareaId.present) {
      map['tarea_id'] = Variable<String>(tareaId.value);
    }
    if (minutosAntes.present) {
      map['minutos_antes'] = Variable<int>(minutosAntes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('tareaId: $tareaId, ')
          ..write('minutosAntes: $minutosAntes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CoursesTable courses = $CoursesTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $SubtasksTable subtasks = $SubtasksTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final Index idxTasksCurso = Index(
    'idx_tasks_curso',
    'CREATE INDEX idx_tasks_curso ON tasks (curso_id)',
  );
  late final Index idxTasksEntrega = Index(
    'idx_tasks_entrega',
    'CREATE INDEX idx_tasks_entrega ON tasks (fecha_entrega)',
  );
  late final Index idxSubtasksTarea = Index(
    'idx_subtasks_tarea',
    'CREATE INDEX idx_subtasks_tarea ON subtasks (tarea_id)',
  );
  late final Index idxRemindersTarea = Index(
    'idx_reminders_tarea',
    'CREATE UNIQUE INDEX idx_reminders_tarea ON reminders (tarea_id)',
  );
  late final CursosDao cursosDao = CursosDao(this as AppDatabase);
  late final TareasDao tareasDao = TareasDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    courses,
    tasks,
    subtasks,
    reminders,
    idxTasksCurso,
    idxTasksEntrega,
    idxSubtasksTarea,
    idxRemindersTarea,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('subtasks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminders', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CoursesTableCreateCompanionBuilder =
    CoursesCompanion Function({
      required String id,
      required String nombre,
      Value<String> docente,
      required int color,
      Value<List<String>> dias,
      Value<String> horaInicio,
      Value<String> horaFin,
      Value<String> periodo,
      Value<DateTime> creadoEn,
      Value<int> rowid,
    });
typedef $$CoursesTableUpdateCompanionBuilder =
    CoursesCompanion Function({
      Value<String> id,
      Value<String> nombre,
      Value<String> docente,
      Value<int> color,
      Value<List<String>> dias,
      Value<String> horaInicio,
      Value<String> horaFin,
      Value<String> periodo,
      Value<DateTime> creadoEn,
      Value<int> rowid,
    });

final class $$CoursesTableReferences
    extends BaseReferences<_$AppDatabase, $CoursesTable, CursoFila> {
  $$CoursesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TasksTable, List<TareaFila>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'courses__id__tasks__curso_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.cursoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CoursesTableFilterComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get docente => $composableBuilder(
    column: $table.docente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get dias =>
      $composableBuilder(
        column: $table.dias,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get horaInicio => $composableBuilder(
    column: $table.horaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get horaFin => $composableBuilder(
    column: $table.horaFin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.cursoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CoursesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get docente => $composableBuilder(
    column: $table.docente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dias => $composableBuilder(
    column: $table.dias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get horaInicio => $composableBuilder(
    column: $table.horaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get horaFin => $composableBuilder(
    column: $table.horaFin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodo => $composableBuilder(
    column: $table.periodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoursesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get docente =>
      $composableBuilder(column: $table.docente, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get dias =>
      $composableBuilder(column: $table.dias, builder: (column) => column);

  GeneratedColumn<String> get horaInicio => $composableBuilder(
    column: $table.horaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get horaFin =>
      $composableBuilder(column: $table.horaFin, builder: (column) => column);

  GeneratedColumn<String> get periodo =>
      $composableBuilder(column: $table.periodo, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.cursoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CoursesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoursesTable,
          CursoFila,
          $$CoursesTableFilterComposer,
          $$CoursesTableOrderingComposer,
          $$CoursesTableAnnotationComposer,
          $$CoursesTableCreateCompanionBuilder,
          $$CoursesTableUpdateCompanionBuilder,
          (CursoFila, $$CoursesTableReferences),
          CursoFila,
          PrefetchHooks Function({bool tasksRefs})
        > {
  $$CoursesTableTableManager(_$AppDatabase db, $CoursesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoursesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoursesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoursesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> docente = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<List<String>> dias = const Value.absent(),
                Value<String> horaInicio = const Value.absent(),
                Value<String> horaFin = const Value.absent(),
                Value<String> periodo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoursesCompanion(
                id: id,
                nombre: nombre,
                docente: docente,
                color: color,
                dias: dias,
                horaInicio: horaInicio,
                horaFin: horaFin,
                periodo: periodo,
                creadoEn: creadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nombre,
                Value<String> docente = const Value.absent(),
                required int color,
                Value<List<String>> dias = const Value.absent(),
                Value<String> horaInicio = const Value.absent(),
                Value<String> horaFin = const Value.absent(),
                Value<String> periodo = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoursesCompanion.insert(
                id: id,
                nombre: nombre,
                docente: docente,
                color: color,
                dias: dias,
                horaInicio: horaInicio,
                horaFin: horaFin,
                periodo: periodo,
                creadoEn: creadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CoursesTable, CursoFila>(table),
                  $$CoursesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tasksRefs) db.tasks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksRefs)
                    await $_getPrefetchedDataByColumns<
                      CursoFila,
                      $CoursesTable,
                      TareaFila,
                      $TasksTable
                    >(
                      currentTable: table,
                      referencedTable: $$CoursesTableReferences._tasksRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$CoursesTableReferences(db, table, p0).tasksRefs,
                      currentColumn: 'id',
                      referencedColumn: 'curso_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CoursesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoursesTable,
      CursoFila,
      $$CoursesTableFilterComposer,
      $$CoursesTableOrderingComposer,
      $$CoursesTableAnnotationComposer,
      $$CoursesTableCreateCompanionBuilder,
      $$CoursesTableUpdateCompanionBuilder,
      (CursoFila, $$CoursesTableReferences),
      CursoFila,
      PrefetchHooks Function({bool tasksRefs})
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String cursoId,
      required String titulo,
      Value<String> descripcion,
      required TipoTarea tipo,
      required Prioridad prioridad,
      required EstadoTarea estado,
      required DateTime fechaEntrega,
      Value<DateTime> creadaEn,
      Value<DateTime> actualizadaEn,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> cursoId,
      Value<String> titulo,
      Value<String> descripcion,
      Value<TipoTarea> tipo,
      Value<Prioridad> prioridad,
      Value<EstadoTarea> estado,
      Value<DateTime> fechaEntrega,
      Value<DateTime> creadaEn,
      Value<DateTime> actualizadaEn,
      Value<int> rowid,
    });

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, TareaFila> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CoursesTable _cursoIdTable(_$AppDatabase db) =>
      db.courses.createAlias('tasks__curso_id__courses__id');

  $$CoursesTableProcessedTableManager get cursoId {
    final $_column = $_itemColumn<String>('curso_id')!;

    final manager = $$CoursesTableTableManager(
      $_db,
      $_db.courses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cursoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SubtasksTable, List<SubtareaFila>>
  _subtasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.subtasks,
    aliasName: 'tasks__id__subtasks__tarea_id',
  );

  $$SubtasksTableProcessedTableManager get subtasksRefs {
    final manager = $$SubtasksTableTableManager(
      $_db,
      $_db.subtasks,
    ).filter((f) => f.tareaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subtasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<RecordatorioFila>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'tasks__id__reminders__tarea_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.tareaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoTarea, TipoTarea, String> get tipo =>
      $composableBuilder(
        column: $table.tipo,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Prioridad, Prioridad, String> get prioridad =>
      $composableBuilder(
        column: $table.prioridad,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<EstadoTarea, EstadoTarea, String> get estado =>
      $composableBuilder(
        column: $table.estado,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadaEn => $composableBuilder(
    column: $table.actualizadaEn,
    builder: (column) => ColumnFilters(column),
  );

  $$CoursesTableFilterComposer get cursoId {
    final $$CoursesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cursoId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableFilterComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> subtasksRefs(
    Expression<bool> Function($$SubtasksTableFilterComposer f) f,
  ) {
    final $$SubtasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subtasks,
      getReferencedColumn: (t) => t.tareaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtasksTableFilterComposer(
            $db: $db,
            $table: $db.subtasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.tareaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prioridad => $composableBuilder(
    column: $table.prioridad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadaEn => $composableBuilder(
    column: $table.creadaEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadaEn => $composableBuilder(
    column: $table.actualizadaEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$CoursesTableOrderingComposer get cursoId {
    final $$CoursesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cursoId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableOrderingComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TipoTarea, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Prioridad, String> get prioridad =>
      $composableBuilder(column: $table.prioridad, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EstadoTarea, String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadaEn =>
      $composableBuilder(column: $table.creadaEn, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadaEn => $composableBuilder(
    column: $table.actualizadaEn,
    builder: (column) => column,
  );

  $$CoursesTableAnnotationComposer get cursoId {
    final $$CoursesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cursoId,
      referencedTable: $db.courses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CoursesTableAnnotationComposer(
            $db: $db,
            $table: $db.courses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> subtasksRefs<T extends Object>(
    Expression<T> Function($$SubtasksTableAnnotationComposer a) f,
  ) {
    final $$SubtasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subtasks,
      getReferencedColumn: (t) => t.tareaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubtasksTableAnnotationComposer(
            $db: $db,
            $table: $db.subtasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.tareaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TareaFila,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TareaFila, $$TasksTableReferences),
          TareaFila,
          PrefetchHooks Function({
            bool cursoId,
            bool subtasksRefs,
            bool remindersRefs,
          })
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cursoId = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<TipoTarea> tipo = const Value.absent(),
                Value<Prioridad> prioridad = const Value.absent(),
                Value<EstadoTarea> estado = const Value.absent(),
                Value<DateTime> fechaEntrega = const Value.absent(),
                Value<DateTime> creadaEn = const Value.absent(),
                Value<DateTime> actualizadaEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                cursoId: cursoId,
                titulo: titulo,
                descripcion: descripcion,
                tipo: tipo,
                prioridad: prioridad,
                estado: estado,
                fechaEntrega: fechaEntrega,
                creadaEn: creadaEn,
                actualizadaEn: actualizadaEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cursoId,
                required String titulo,
                Value<String> descripcion = const Value.absent(),
                required TipoTarea tipo,
                required Prioridad prioridad,
                required EstadoTarea estado,
                required DateTime fechaEntrega,
                Value<DateTime> creadaEn = const Value.absent(),
                Value<DateTime> actualizadaEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                cursoId: cursoId,
                titulo: titulo,
                descripcion: descripcion,
                tipo: tipo,
                prioridad: prioridad,
                estado: estado,
                fechaEntrega: fechaEntrega,
                creadaEn: creadaEn,
                actualizadaEn: actualizadaEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, TareaFila>(table),
                  $$TasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({cursoId = false, subtasksRefs = false, remindersRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (subtasksRefs) db.subtasks,
                    if (remindersRefs) db.reminders,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cursoId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cursoId,
                                    referencedTable: $$TasksTableReferences
                                        ._cursoIdTable(db),
                                    referencedColumn: $$TasksTableReferences
                                        ._cursoIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (subtasksRefs)
                        await $_getPrefetchedDataByColumns<
                          TareaFila,
                          $TasksTable,
                          SubtareaFila,
                          $SubtasksTable
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._subtasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).subtasksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'tarea_id',
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedDataByColumns<
                          TareaFila,
                          $TasksTable,
                          RecordatorioFila,
                          $RemindersTable
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'tarea_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TareaFila,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TareaFila, $$TasksTableReferences),
      TareaFila,
      PrefetchHooks Function({
        bool cursoId,
        bool subtasksRefs,
        bool remindersRefs,
      })
    >;
typedef $$SubtasksTableCreateCompanionBuilder =
    SubtasksCompanion Function({
      required String id,
      required String tareaId,
      required String titulo,
      Value<bool> hecha,
      required int posicion,
      Value<int> rowid,
    });
typedef $$SubtasksTableUpdateCompanionBuilder =
    SubtasksCompanion Function({
      Value<String> id,
      Value<String> tareaId,
      Value<String> titulo,
      Value<bool> hecha,
      Value<int> posicion,
      Value<int> rowid,
    });

final class $$SubtasksTableReferences
    extends BaseReferences<_$AppDatabase, $SubtasksTable, SubtareaFila> {
  $$SubtasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _tareaIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('subtasks__tarea_id__tasks__id');

  $$TasksTableProcessedTableManager get tareaId {
    final $_column = $_itemColumn<String>('tarea_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tareaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubtasksTableFilterComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hecha => $composableBuilder(
    column: $table.hecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get posicion => $composableBuilder(
    column: $table.posicion,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get tareaId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tareaId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubtasksTableOrderingComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hecha => $composableBuilder(
    column: $table.hecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get posicion => $composableBuilder(
    column: $table.posicion,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get tareaId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tareaId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubtasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<bool> get hecha =>
      $composableBuilder(column: $table.hecha, builder: (column) => column);

  GeneratedColumn<int> get posicion =>
      $composableBuilder(column: $table.posicion, builder: (column) => column);

  $$TasksTableAnnotationComposer get tareaId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tareaId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubtasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubtasksTable,
          SubtareaFila,
          $$SubtasksTableFilterComposer,
          $$SubtasksTableOrderingComposer,
          $$SubtasksTableAnnotationComposer,
          $$SubtasksTableCreateCompanionBuilder,
          $$SubtasksTableUpdateCompanionBuilder,
          (SubtareaFila, $$SubtasksTableReferences),
          SubtareaFila,
          PrefetchHooks Function({bool tareaId})
        > {
  $$SubtasksTableTableManager(_$AppDatabase db, $SubtasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubtasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubtasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubtasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tareaId = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<bool> hecha = const Value.absent(),
                Value<int> posicion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubtasksCompanion(
                id: id,
                tareaId: tareaId,
                titulo: titulo,
                hecha: hecha,
                posicion: posicion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tareaId,
                required String titulo,
                Value<bool> hecha = const Value.absent(),
                required int posicion,
                Value<int> rowid = const Value.absent(),
              }) => SubtasksCompanion.insert(
                id: id,
                tareaId: tareaId,
                titulo: titulo,
                hecha: hecha,
                posicion: posicion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubtasksTable, SubtareaFila>(table),
                  $$SubtasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tareaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tareaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tareaId,
                                referencedTable: $$SubtasksTableReferences
                                    ._tareaIdTable(db),
                                referencedColumn: $$SubtasksTableReferences
                                    ._tareaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SubtasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubtasksTable,
      SubtareaFila,
      $$SubtasksTableFilterComposer,
      $$SubtasksTableOrderingComposer,
      $$SubtasksTableAnnotationComposer,
      $$SubtasksTableCreateCompanionBuilder,
      $$SubtasksTableUpdateCompanionBuilder,
      (SubtareaFila, $$SubtasksTableReferences),
      SubtareaFila,
      PrefetchHooks Function({bool tareaId})
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      required String tareaId,
      required int minutosAntes,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      Value<String> tareaId,
      Value<int> minutosAntes,
    });

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, RecordatorioFila> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _tareaIdTable(_$AppDatabase db) =>
      db.tasks.createAlias('reminders__tarea_id__tasks__id');

  $$TasksTableProcessedTableManager get tareaId {
    final $_column = $_itemColumn<String>('tarea_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tareaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutosAntes => $composableBuilder(
    column: $table.minutosAntes,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get tareaId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tareaId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutosAntes => $composableBuilder(
    column: $table.minutosAntes,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get tareaId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tareaId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get minutosAntes => $composableBuilder(
    column: $table.minutosAntes,
    builder: (column) => column,
  );

  $$TasksTableAnnotationComposer get tareaId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tareaId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          RecordatorioFila,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (RecordatorioFila, $$RemindersTableReferences),
          RecordatorioFila,
          PrefetchHooks Function({bool tareaId})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tareaId = const Value.absent(),
                Value<int> minutosAntes = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                tareaId: tareaId,
                minutosAntes: minutosAntes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tareaId,
                required int minutosAntes,
              }) => RemindersCompanion.insert(
                id: id,
                tareaId: tareaId,
                minutosAntes: minutosAntes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, RecordatorioFila>(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tareaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tareaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tareaId,
                                referencedTable: $$RemindersTableReferences
                                    ._tareaIdTable(db),
                                referencedColumn: $$RemindersTableReferences
                                    ._tareaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      RecordatorioFila,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (RecordatorioFila, $$RemindersTableReferences),
      RecordatorioFila,
      PrefetchHooks Function({bool tareaId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CoursesTableTableManager get courses =>
      $$CoursesTableTableManager(_db, _db.courses);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$SubtasksTableTableManager get subtasks =>
      $$SubtasksTableTableManager(_db, _db.subtasks);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
}

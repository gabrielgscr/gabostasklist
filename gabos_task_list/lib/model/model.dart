import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import '../tools/helper.dart';
import 'view.list.dart';

part 'model.g.dart';
part 'model.g.view.dart';

// Person table model
const tablePerson = SqfEntityTable(
  tableName: 'persons',
  primaryKeyName: 'personId',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('firstName', DbType.text),
    SqfEntityField('lastName', DbType.text),
    SqfEntityField('email', DbType.text),
    SqfEntityField('phone', DbType.text),
    SqfEntityField('createdDate', DbType.datetime),
    SqfEntityField('updatedDate', DbType.datetime),
  ],
);

const tableTask = SqfEntityTable(
  tableName: 'tasks',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('title', DbType.text),
    SqfEntityField('description', DbType.text),
    SqfEntityField('dueDate', DbType.datetime),
    SqfEntityField('isCompleted', DbType.bool, defaultValue: false),
    SqfEntityField('createdDate', DbType.datetime),
    SqfEntityField('updatedDate', DbType.datetime),
    //relation with person table
    SqfEntityFieldRelationship(
        parentTable: tablePerson,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: 1,
        fieldName: 'personId'),
  ],
);

// Define the 'identity' constant as SqfEntitySequence.
const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
  //maxValue:  10000, /* optional. default is max int (9.223.372.036.854.775.807) */
  //modelName: 'SQEidentity',
  /* optional. SqfEntity will set it to sequenceName automatically when the modelName is null*/
  //cycle : false,    /* optional. default is false; */
  //minValue = 0;     /* optional. default is 0 */
  //incrementBy = 1;  /* optional. default is 1 */
  // startWith = 0;   /* optional. default is 0 */
);

//
@SqfEntityBuilder(model)
const model = SqfEntityModel(
  modelName: 'TaskModel',
  databaseName: 'gabos_task_database.db',
  databaseTables: [tablePerson, tableTask],
  formTables: [tablePerson],
  sequences: [seqIdentity],
  dbVersion: 5,
);

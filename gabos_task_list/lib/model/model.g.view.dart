// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SqfEntityFormGenerator
// **************************************************************************

part of 'model.dart';

class PersonAdd extends StatefulWidget {
  PersonAdd(this._persons);
  final dynamic _persons;
  @override
  State<StatefulWidget> createState() => PersonAddState(_persons as Person);
}

class PersonAddState extends State {
  PersonAddState(this.persons);
  Person persons;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController txtFirstName = TextEditingController();
  final TextEditingController txtLastName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPhone = TextEditingController();
  final TextEditingController txtCreatedDate = TextEditingController();
  final TextEditingController txtTimeForCreatedDate = TextEditingController();
  final TextEditingController txtUpdatedDate = TextEditingController();
  final TextEditingController txtTimeForUpdatedDate = TextEditingController();

  @override
  void initState() {
    txtFirstName.text =
        persons.firstName == null ? '' : persons.firstName.toString();
    txtLastName.text =
        persons.lastName == null ? '' : persons.lastName.toString();
    txtEmail.text = persons.email == null ? '' : persons.email.toString();
    txtPhone.text = persons.phone == null ? '' : persons.phone.toString();
    txtCreatedDate.text = persons.createdDate == null
        ? ''
        : UITools.convertDate(persons.createdDate!);
    txtTimeForCreatedDate.text = persons.createdDate == null
        ? ''
        : UITools.convertTime(persons.createdDate!);

    txtUpdatedDate.text = persons.updatedDate == null
        ? ''
        : UITools.convertDate(persons.updatedDate!);
    txtTimeForUpdatedDate.text = persons.updatedDate == null
        ? ''
        : UITools.convertTime(persons.updatedDate!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (persons.personId == null)
            ? Text('Add a new persons')
            : Text('Edit persons'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    buildRowFirstName(),
                    buildRowLastName(),
                    buildRowEmail(),
                    buildRowPhone(),
                    buildRowCreatedDate(),
                    buildRowUpdatedDate(),
                    TextButton(
                      child: saveButton(),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a Snackbar.
                          save();
                          /* Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Processing Data')));
                           */
                        }
                      },
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildRowFirstName() {
    return TextFormField(
      controller: txtFirstName,
      decoration: InputDecoration(labelText: 'FirstName'),
    );
  }

  Widget buildRowLastName() {
    return TextFormField(
      controller: txtLastName,
      decoration: InputDecoration(labelText: 'LastName'),
    );
  }

  Widget buildRowEmail() {
    return TextFormField(
      controller: txtEmail,
      decoration: InputDecoration(labelText: 'Email'),
    );
  }

  Widget buildRowPhone() {
    return TextFormField(
      controller: txtPhone,
      decoration: InputDecoration(labelText: 'Phone'),
    );
  }

  Widget buildRowCreatedDate() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => UITools.showDateTimePicker(context,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtCreatedDate.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForCreatedDate.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtCreatedDate.text) ??
                  persons.createdDate ??
                  DateTime.now();
              persons.createdDate = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtCreatedDate.text) ??
                  persons.createdDate ??
                  DateTime.now()),
          controller: txtCreatedDate,
          decoration: InputDecoration(labelText: 'CreatedDate'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => UITools.showDateTimePicker(context,
                onConfirm: (sqfSelectedDate) {
              txtTimeForCreatedDate.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtCreatedDate.text) ??
                    persons.createdDate ??
                    DateTime.now();
                persons.createdDate = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtCreatedDate.text = UITools.convertDate(persons.createdDate!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForCreatedDate.text}') ??
                    persons.createdDate ??
                    DateTime.now()),
            controller: txtTimeForCreatedDate,
            decoration: InputDecoration(labelText: 'time'),
          ))
    ]);
  }

  Widget buildRowUpdatedDate() {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: TextFormField(
          onTap: () => UITools.showDateTimePicker(context,
              minTime: DateTime.parse('1900-01-01'),
              onConfirm: (sqfSelectedDate) {
            txtUpdatedDate.text = UITools.convertDate(sqfSelectedDate);
            txtTimeForUpdatedDate.text = UITools.convertTime(sqfSelectedDate);
            setState(() {
              final d = DateTime.tryParse(txtUpdatedDate.text) ??
                  persons.updatedDate ??
                  DateTime.now();
              persons.updatedDate = DateTime(sqfSelectedDate.year,
                      sqfSelectedDate.month, sqfSelectedDate.day)
                  .add(Duration(
                      hours: d.hour, minutes: d.minute, seconds: d.second));
            });
          },
              currentTime: DateTime.tryParse(txtUpdatedDate.text) ??
                  persons.updatedDate ??
                  DateTime.now()),
          controller: txtUpdatedDate,
          decoration: InputDecoration(labelText: 'UpdatedDate'),
        ),
      ),
      Expanded(
          flex: 1,
          child: TextFormField(
            onTap: () => UITools.showDateTimePicker(context,
                onConfirm: (sqfSelectedDate) {
              txtTimeForUpdatedDate.text = UITools.convertTime(sqfSelectedDate);
              setState(() {
                final d = DateTime.tryParse(txtUpdatedDate.text) ??
                    persons.updatedDate ??
                    DateTime.now();
                persons.updatedDate = DateTime(d.year, d.month, d.day).add(
                    Duration(
                        hours: sqfSelectedDate.hour,
                        minutes: sqfSelectedDate.minute,
                        seconds: sqfSelectedDate.second));
                txtUpdatedDate.text = UITools.convertDate(persons.updatedDate!);
              });
            },
                currentTime: DateTime.tryParse(
                        '${UITools.convertDate(DateTime.now())} ${txtTimeForUpdatedDate.text}') ??
                    persons.updatedDate ??
                    DateTime.now()),
            controller: txtTimeForUpdatedDate,
            decoration: InputDecoration(labelText: 'time'),
          ))
    ]);
  }

  Container saveButton() {
    return Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          color: Color.fromRGBO(95, 66, 119, 1.0),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0)),
      child: Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  void save() async {
    var _createdDate = DateTime.tryParse(txtCreatedDate.text);
    final _createdDateTime = DateTime.tryParse(txtTimeForCreatedDate.text);
    if (_createdDate != null && _createdDateTime != null) {
      _createdDate = _createdDate.add(Duration(
          hours: _createdDateTime.hour,
          minutes: _createdDateTime.minute,
          seconds: _createdDateTime.second));
    }
    var _updatedDate = DateTime.tryParse(txtUpdatedDate.text);
    final _updatedDateTime = DateTime.tryParse(txtTimeForUpdatedDate.text);
    if (_updatedDate != null && _updatedDateTime != null) {
      _updatedDate = _updatedDate.add(Duration(
          hours: _updatedDateTime.hour,
          minutes: _updatedDateTime.minute,
          seconds: _updatedDateTime.second));
    }

    persons
      ..firstName = txtFirstName.text
      ..lastName = txtLastName.text
      ..email = txtEmail.text
      ..phone = txtPhone.text
      ..createdDate = _createdDate
      ..updatedDate = _updatedDate;
    await persons.save();
    if (persons.saveResult!.success) {
      Navigator.pop(context, true);
    } else {
      UITools(context).alertDialog(persons.saveResult.toString(),
          title: 'save Person Failed!', callBack: () {});
    }
  }
}

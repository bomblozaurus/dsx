import 'dart:io';

import 'package:dsx/models/pojo/ad_pojo.dart';
import 'package:dsx/models/scope.dart';
import 'package:dsx/models/user_details.dart';
import 'package:dsx/style/theme.dart' as DsxTheme;
import 'package:dsx/utils/api_image.dart';
import 'package:dsx/utils/flushbar_utils.dart';
import 'package:dsx/utils/requests.dart';
import 'package:dsx/utils/simple_step.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:image_picker/image_picker.dart';

class AdForm extends StatefulWidget {
  final UserDetails userDetails;

  const AdForm({Key key, this.userDetails}) : super(key: key);

  @override
  _AdFormState createState() => _AdFormState();
}

class _AdFormState extends State<AdForm> {
  static const _darkGrey = DsxTheme.Colors.loginGradientEnd;
  static const _lime = DsxTheme.Colors.logoBackgroundColor;
  static var _lightStyle = DsxTheme.TextStyles.descriptionTextStyle;

  TextEditingController _titleController;
  TextEditingController _cityController;
  TextEditingController _streetController;
  TextEditingController _houseController;
  TextEditingController _apartmentController;
  TextEditingController _zipController;
  TextEditingController _descriptionController;
  TextEditingController _priceController;

  FocusNode _titleNode;
  FocusNode _cityNode;
  FocusNode _streetNode;
  FocusNode _houseNode;
  FocusNode _apartmentNode;
  FocusNode _zipNode;
  FocusNode _descriptionNode;
  FocusNode _priceNode;

  File _image;
  int _imageId;
  bool _submitBlocked = false;

  Map<String, String> _scopes = {
    "Wszyscy": Scope.OTHER.name,
  };

  String _selectedScope = Scope.OTHER.name;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _cityController = TextEditingController();
    _streetController = TextEditingController();
    _houseController = TextEditingController();
    _apartmentController = TextEditingController();
    _zipController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();

    _titleNode = FocusNode();
    _cityNode = FocusNode();
    _streetNode = FocusNode();
    _houseNode = FocusNode();
    _apartmentNode = FocusNode();
    _zipNode = FocusNode();
    _descriptionNode = FocusNode();
    _priceNode = FocusNode();

    if (widget.userDetails.isStudent()) {
      _scopes.addAll({"Studenci": Scope.STUDENT.name});
    }

    if (widget.userDetails.isDormitory()) {
      _scopes.addAll({"Dom studencki": Scope.DORMITORY.name});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _houseController.dispose();
    _apartmentController.dispose();
    _zipController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();

    _titleNode.dispose();
    _cityNode.dispose();
    _streetNode.dispose();
    _houseNode.dispose();
    _apartmentNode.dispose();
    _zipNode.dispose();
    _descriptionNode.dispose();
    _priceNode.dispose();
  }

  InputDecoration _inputDecoration(String label, IconData iconData) =>
      InputDecoration(
          prefixIcon: Icon(iconData, color: Colors.white),
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: _lime)));

  int _currentStep = 0;
  int _stepsCount = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: Brightness.dark, accentColor: _lime),
      child: Stepper(
        onStepContinue: () => onStepContinue(context),
        onStepCancel: onStepCancel,
        onStepTapped: onStepTapped,
        currentStep: _currentStep,
        steps: _getSteps(),
      ),
    );
  }

  List<Step> _getSteps() {
    List<Step> steps = [
      SimpleStep(
          title: "Tytuł",
          subtitle: "Krótki i jednoznaczny",
          content: _buildTitleInput()),
      SimpleStep(
          title: "Zdjęcie",
          subtitle: "Wybierz istniejące albo zrób nowe",
          content: _buildImageInput()),
      SimpleStep(
          title: "Adres",
          subtitle: "Twój albo punktu odbioru",
          content: _buildAddressInput()),
      SimpleStep(
          title: "Opis",
          subtitle: "Informatywny i treściwy",
          content: _buildDescriptionInput()),
      SimpleStep(
          title: "Zasięg",
          subtitle: "Ogranicz widoczność ogłoszenia",
          content: _buildScopeInput()),
    ]
        .asMap()
        .map((index, step) =>
            MapEntry(index, SimpleStep.toStep(index, step, _currentStep)))
        .values
        .toList();

    setState(() {
      _stepsCount = steps.length;
    });

    return steps;
  }

  Widget _buildAddressInput() => Column(
        children: <Widget>[
          _buildTextInput(
            title: "Miasto",
            iconData: Icons.location_city,
            controller: _cityController,
            focusNode: _cityNode,
            onSubmitFocusNode: _streetNode,
          ),
          SizedBox(height: 10),
          _buildTextInput(
            title: "Ulica",
            iconData: Icons.location_city,
            controller: _streetController,
            focusNode: _streetNode,
            onSubmitFocusNode: _houseNode,
          ),
          SizedBox(height: 10),
          _buildNumericInput(
            title: "Numer budynku",
            iconData: Icons.home,
            controller: _houseController,
            focusNode: _houseNode,
            onSubmitFocusNode: _apartmentNode,
          ),
          SizedBox(height: 10),
          _buildNumericInput(
            title: "Numer mieszkania",
            iconData: Icons.home,
            controller: _apartmentController,
            focusNode: _apartmentNode,
            onSubmitFocusNode: _zipNode,
          ),
          SizedBox(height: 10),
          _buildNumericInput(
              title: "Kod pocztowy",
              iconData: Icons.map,
              controller: _zipController,
              focusNode: _zipNode,
              onSubmitFocusNode: null),
        ],
      );

  Widget _buildDescriptionInput() {
    return Column(
      children: <Widget>[
        _buildDecimalInput(
            title: "Cena",
            iconData: Icons.monetization_on,
            controller: _priceController,
            focusNode: _priceNode,
            onSubmitFocusNode: _descriptionNode),
        SizedBox(height: 10.0),
        _buildTextInput(
            title: "Opis",
            iconData: Icons.description,
            controller: _descriptionController,
            focusNode: _descriptionNode,
            onSubmitFocusNode: null),
      ],
    );
  }

  Widget _buildScopeInput() => Wrap(
      spacing: 10.0,
      runAlignment: WrapAlignment.spaceAround,
      children: _scopes
          .map((name, enumValue) => MapEntry(
              enumValue,
              ChoiceChip(
                  label: Text(name, style: _lightStyle),
                  selected: _selectedScope == enumValue,
                  selectedColor: DsxTheme.Colors.logoBackgroundColor,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedScope = enumValue;
                    });
                  })))
          .values
          .toList());

  Widget _buildTitleInput() => _buildTextInput(
      title: "Tytuł ogłoszenia",
      iconData: Icons.library_books,
      controller: _titleController,
      focusNode: _titleNode,
      onSubmitFocusNode: null);

  Widget _buildImageInput() {
    Future getImage(ImageSource source) async {
      ImagePicker.pickImage(source: source).then((image) {
        setState(() {
          _submitBlocked = true;
          _image = image;
        });

        ApiImage.uploadImage(_image).then((id) {
          setState(() {
            _imageId = id;
            _submitBlocked = false;
          });
        });
      });
    }

    _getChild() {
      if (_image != null) {
        return Image.file(_image);
      }
      return Text("Wybierz zdjęcie",
          style: DsxTheme.TextStyles.descriptionTextStyle);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _getChild(),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildButton(
              onPressed: () => getImage(ImageSource.camera),
              child: Icon(Icons.camera_alt, color: Colors.white),
            ),
            _buildButton(
              onPressed: () => getImage(ImageSource.gallery),
              child: Icon(Icons.photo, color: Colors.white),
            ),
            _buildButton(
              onPressed: () {
                setState(() {
                  _image = null;
                });
              },
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  onStepContinue(context) => _currentStep != _stepsCount - 1
      ? _setCurrentStep(++_currentStep)
      : _submitAd(context);

  onStepCancel() => _currentStep != 0 ? _setCurrentStep(--_currentStep) : null;

  onStepTapped(int index) => _setCurrentStep(index);

  _setCurrentStep(int index) {
    setState(() {
      _currentStep = index;
    });
  }

  _submitAd(context) {
    if (_submitBlocked) {
      _showFlushbarWithSubmitError(context);
      return;
    }

    try {
      var ad = AdPOJO(
        name: _titleController.text.trim(),
        street: _streetController.text.trim(),
        houseNumber: int.tryParse(_houseController.text.trim()) ?? null,
        apartmentNumber:
            int.tryParse(_apartmentController.text?.trim()) ?? null,
        city: _cityController.text?.trim(),
        zip: _zipController.text?.trim(),
        description: _descriptionController.text?.trim(),
        mainImage: _imageId,
        scope: _selectedScope,
        price: double.tryParse(
                _priceController.text.replaceAll(',', '.').trim()) ??
            0.0,
      );

      Map<String, dynamic> body = ad.toJson();

      String resourcePath = GlobalConfiguration().getString("adsPostUrl");
      Request()
          .postToMobileApi(resourcePath: resourcePath, body: body)
          .then((response) {
        if (response.statusCode == HttpStatus.created) {
          _showFlushbarWithSuccessInfo(context);
        }
      });
    } catch (e) {
      _showFlushbarWithValidationError(context);
    }
  }

  void _showFlushbarWithSubmitError(context) {
    FlushbarUtils.showFlushbar(
      context: context,
      title: "Niepowodzenie",
      message:
      "Nie można stworzyć ogłoszenia, ponieważ trwa przesyłanie zdjęcia. Spróbuj ponownie za kilka sekund.",
      color: _darkGrey,
      icon: Icon(Icons.warning, color: Colors.red),
    );
  }

  void _showFlushbarWithSuccessInfo(context) {
    FlushbarUtils.showFlushbar(
      context: context,
      title: "Sukces",
      message: "Ogłoszenie zostało dodane pomyślnie",
      color: _darkGrey,
      icon: Icon(Icons.done, color: _lime),
    );
  }

  Widget _buildButton({Function onPressed, Widget child}) =>
      SizedBox(
        width: 64.0,
        child: OutlineButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          borderSide: BorderSide(color: DsxTheme.Colors.logoBackgroundColor),
          onPressed: onPressed,
          child: child,
        ),
      );

  Widget _buildInput(
          {String title,
          IconData iconData,
          TextEditingController controller,
          FocusNode focusNode,
          FocusNode onSubmitFocusNode,
          TextInputType keyboardType}) =>
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: TextField(
          keyboardType: keyboardType,
          focusNode: focusNode,
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(onSubmitFocusNode ?? null),
          controller: controller,
          style: _lightStyle,
          decoration: _inputDecoration(title, iconData),
        ),
      );

  Widget _buildTextInput(
          {String title,
          IconData iconData,
          TextEditingController controller,
          FocusNode focusNode,
          FocusNode onSubmitFocusNode}) =>
      _buildInput(
          title: title,
          iconData: iconData,
          controller: controller,
          focusNode: focusNode,
          onSubmitFocusNode: onSubmitFocusNode,
          keyboardType: TextInputType.text);

  Widget _buildDecimalInput(
          {String title,
          IconData iconData,
          TextEditingController controller,
          FocusNode focusNode,
          FocusNode onSubmitFocusNode}) =>
      _buildInput(
          title: title,
          iconData: iconData,
          controller: controller,
          focusNode: focusNode,
          onSubmitFocusNode: onSubmitFocusNode,
          keyboardType: TextInputType.numberWithOptions(decimal: true));

  Widget _buildNumericInput(
          {String title,
          IconData iconData,
            TextEditingController controller,
            FocusNode focusNode,
            FocusNode onSubmitFocusNode}) =>
      _buildInput(
          title: title,
          iconData: iconData,
          controller: controller,
          focusNode: focusNode,
          onSubmitFocusNode: onSubmitFocusNode,
          keyboardType: TextInputType.number);

  void _showFlushbarWithValidationError(context) {
    FlushbarUtils.showFlushbar(
      context: context,
      title: "Niepoprawne dane",
      message:
      "Sprawdź poprwaność wprowadzonych danych i spróbuj ponownie",
      color: _darkGrey,
      icon: Icon(Icons.warning, color: Colors.red),
    );
  }
}

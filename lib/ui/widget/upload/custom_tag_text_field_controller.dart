import 'package:textfield_tags/textfield_tags.dart';

class CustomTagTextFieldController extends TextfieldTagsController {
  Function setIsTagsFillPutState;

  CustomTagTextFieldController(this.setIsTagsFillPutState) : super();

  @override
  set removeTag(String tag) {
    super.removeTag = tag;
    setIsTagsFillPutState(getTags!.isNotEmpty);
  }

  // 동작X, addTag(String tag)도, onSubmitted에도 동작 X...
  // @override
  // set addTag(String value) {
  //   setIsTagsFillPutState(true);
  //   super.addTag = value;
  // }
}

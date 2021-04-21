import 'package:flokk/_internal/log.dart';
import 'package:flokk/commands/abstract_command.dart';
import 'package:flokk/data/group_data.dart';
import 'package:flokk/services/service_result.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateLabelCommand extends AbstractCommand with AuthorizedServiceCommandMixin {
  CreateLabelCommand(BuildContext c) : super(c);

  Future<GroupData> execute(String labelName) async {
    Log.p("[CreateLabelCommand]");
    GroupData newGroup = GroupData()..name = labelName;
    ServiceResult<GroupData> result = await executeAuthServiceCmd(() async {
      ServiceResult<GroupData> result = await googleRestService.groups.create(authModel.googleAccessToken, newGroup);
      newGroup = result.content;

      if (result.success) {
        contactsModel.allGroups.add(newGroup);
      }
      return result;
    });
    return result.success ? newGroup : GroupData();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import '../../../../common/app_theme.dart';
import '../../../../common/constants.dart';
import '../../../../common/widgets.dart';
import '../../../../data/helper.dart';
import '../../../../widgets/custom_action_bar_icons.dart';
import '../../../../widgets/widgets.dart';
import '../../chat/chat_widgets.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        debugPrint('onFocusGained');
        // controller.initListeners();
        controller.checkArchiveSetting();
        controller.getRecentChatList();
      },
      child: WillPopScope(
        onWillPop: () {
          if (controller.selected.value) {
            controller.clearAllChatSelection();
            return Future.value(false);
          } else if (controller.isSearching.value) {
            controller.getBackFromSearch();
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: CustomSafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Chat Mirror Fly"),
              centerTitle: true,
            ),
            body: Obx(() {
              return chatView(context);
            }),
          ),
        ),
      ),
    );
  }

  Widget chatView(BuildContext context) {
    return controller.clearVisible.value
        ? recentSearchView(context)
        : Stack(
            children: [
              Obx(() {
                return Visibility(
                    visible: !controller.recentChatLoding.value &&
                        controller.recentChats.isEmpty &&
                        controller.archivedChats.isEmpty,
                    child: emptyChat(context));
              }),
              Column(
                children: [
                  Obx(() {
                    return Visibility(
                      visible: controller.archivedChats.isNotEmpty &&
                          controller.archiveSettingEnabled
                              .value /*&& controller.archivedCount.isNotEmpty*/,
                      child: ListItem(
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SvgPicture.asset(archive),
                        ),
                        title: const Text(
                          "Archived",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: controller.archivedCount != "0"
                            ? Text(
                                controller.archivedCount,
                                style: const TextStyle(color: buttonBgColor),
                              )
                            : null,
                        dividerPadding: EdgeInsets.zero,
                        onTap: () {},
                      ),
                    );
                  }),
                  Expanded(
                      child: /*FutureBuilder(
                  future: controller.getRecentChatList(),
                  builder: (c, d) {*/
                          Obx(() {
                    return controller.recentChatLoding.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.recentChats.length + 1,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (index < controller.recentChats.length) {
                                var item = controller.recentChats[index];
                                return Obx(() {
                                  return RecentChatItem(
                                    item: item,
                                    isSelected: controller.isSelected(index),
                                    typingUserid: controller
                                        .typingUser(item.jid.checkNull()),
                                    onTap: () {
                                      if (controller.selected.value) {
                                        controller
                                            .selectOrRemoveChatfromList(index);
                                      } else {
                                        controller
                                            .toChatPage(item.jid.checkNull());
                                      }
                                    },
                                    onLongPress: () {
                                      controller.selected(true);
                                      controller
                                          .selectOrRemoveChatfromList(index);
                                    },
                                    onAvatarClick: () {
                                      controller.getProfileDetail(
                                          context, item, index);
                                    },
                                  );
                                });
                              } else {
                                return Obx(() {
                                  return Visibility(
                                    visible: controller
                                            .archivedChats.isNotEmpty &&
                                        !controller.archiveSettingEnabled
                                            .value /*&& controller.archivedCount.isNotEmpty*/,
                                    child: ListItem(
                                      leading: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: SvgPicture.asset(archive),
                                      ),
                                      title: const Text(
                                        "Archived",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      trailing: controller
                                              .archivedChats.isNotEmpty
                                          ? Text(
                                              controller.archivedChats.length
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: buttonBgColor),
                                            )
                                          : null,
                                      dividerPadding: EdgeInsets.zero,
                                      onTap: () {},
                                    ),
                                  );
                                });
                              }
                            });
                  })
                      // }),
                      ),
                ],
              )
            ],
          );
  }

  Widget recentSearchView(BuildContext context) {
    return ListView(
      controller: controller.userlistScrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Obx(() {
          return Column(
            children: [
              Visibility(
                visible: controller.filteredRecentChatList.isNotEmpty,
                child: searchHeader(
                    Constants.typeSearchRecent,
                    controller.filteredRecentChatList.length.toString(),
                    context),
              ),
              recentChatListView(),
              Visibility(
                visible: controller.chatMessages.isNotEmpty,
                child: searchHeader(Constants.typeSearchMessage,
                    controller.chatMessages.length.toString(), context),
              ),
              filteredMessageListView(),
              Visibility(
                visible: controller.userList.isNotEmpty &&
                    !controller.searchLoading.value,
                child: searchHeader(Constants.typeSearchContact,
                    controller.userList.length.toString(), context),
              ),
              Visibility(
                  visible: controller.searchLoading.value,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  )),
              Visibility(
                visible: controller.userList.isNotEmpty &&
                    !controller.searchLoading.value,
                child: filteredUsersListView(),
              ),
              Visibility(
                  visible: controller.search.text.isNotEmpty &&
                      controller.filteredRecentChatList.isEmpty &&
                      controller.chatMessages.isEmpty &&
                      controller.userList.isEmpty,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("No data found"),
                    ),
                  ))
            ],
          );
        })
      ],
    );
  }

  ListView filteredUsersListView() {
    return ListView.builder(
        itemCount: controller.scrollable.value
            ? controller.userList.length + 1
            : controller.userList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index >= controller.userList.length &&
              controller.scrollable.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var item = controller.userList[index];
            return memberItem(
              name: getName(item),
              image: item.image.checkNull(),
              status: item.status.checkNull(),
              spantext: controller.search.text.toString(),
              onTap: () {
                controller.toChatPage(item.jid.checkNull());
              },
              isCheckBoxVisible: false,
              isGroup: item.isGroupProfile.checkNull(),
              blocked: item.isBlockedMe.checkNull() ||
                  item.isAdminBlocked.checkNull(),
              unknown: (!item.isItSavedContact.checkNull() ||
                  item.isDeletedContact()),
            );
          }
        });
  }

  ListView filteredMessageListView() {
    return ListView.builder(
        itemCount: controller.chatMessages.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var items = controller.chatMessages[index];
          return FutureBuilder(
              future: controller.getProfileAndMessage(
                  items.chatUserJid.checkNull(), items.messageId.checkNull()),
              builder: (context, snap) {
                if (snap.hasData) {
                  var profile = snap.data!.entries.first.key!;
                  var item = snap.data!.entries.first.value!;
                  var unreadMessageCount = "0";
                  return InkWell(
                    child: Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                                left: 19.0, top: 10, bottom: 10, right: 10),
                            child: Stack(
                              children: [
                                ImageNetwork(
                                  url: profile.image.checkNull(),
                                  width: 48,
                                  height: 48,
                                  clipOval: true,
                                  errorWidget: ProfileTextImage(
                                      text: getName(
                                          profile) /*profile.name
                                        .checkNull()
                                        .isEmpty
                                        ? profile.nickName.checkNull()
                                        : profile.name.checkNull(),*/
                                      ),
                                  isGroup: profile.isGroupProfile.checkNull(),
                                  blocked: profile.isBlockedMe.checkNull() ||
                                      profile.isAdminBlocked.checkNull(),
                                  unknown:
                                      (!profile.isItSavedContact.checkNull() ||
                                          profile.isDeletedContact()),
                                ),
                                unreadMessageCount.toString() != "0"
                                    ? Positioned(
                                        right: 0,
                                        child: CircleAvatar(
                                          radius: 8,
                                          child: Text(
                                            unreadMessageCount.toString(),
                                            style: const TextStyle(
                                                fontSize: 9,
                                                color: Colors.white,
                                                fontFamily: 'sf_ui'),
                                          ),
                                        ))
                                    : const SizedBox(),
                              ],
                            )),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      getName(
                                          profile), //profile.name.toString(),
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'sf_ui',
                                          color: textHintColor),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16.0, left: 8),
                                    child: Text(
                                      getRecentChatTime(context,
                                          item.messageSentTime.toInt()),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'sf_ui',
                                          color:
                                              unreadMessageCount.toString() !=
                                                      "0"
                                                  ? buttonBgColor
                                                  : textColor),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  unreadMessageCount.toString() != "0"
                                      ? const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: CircleAvatar(
                                            radius: 4,
                                            backgroundColor: Colors.green,
                                          ),
                                        )
                                      : const SizedBox(),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: getMessageIndicator(
                                              item.messageStatus.value
                                                  .checkNull(),
                                              item.isMessageSentByMe
                                                  .checkNull(),
                                              item.messageType.checkNull(),
                                              item.isMessageRecalled.value),
                                        ),
                                        item.isMessageRecalled.value
                                            ? const SizedBox.shrink()
                                            : forMessageTypeIcon(
                                                item.messageType,
                                              ),
                                        SizedBox(
                                          width: forMessageTypeString(
                                                      item.messageType,
                                                      content: item
                                                          .mediaChatMessage
                                                          ?.mediaCaptionText
                                                          .checkNull()) !=
                                                  null
                                              ? 3.0
                                              : 0.0,
                                        ),
                                        Expanded(
                                          child: forMessageTypeString(
                                                      item.messageType,
                                                      content: item
                                                          .mediaChatMessage
                                                          ?.mediaCaptionText
                                                          .checkNull()) ==
                                                  null
                                              ? spannableText(
                                                  item.messageTextContent
                                                      .toString(),
                                                  controller.search.text,
                                                  Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                )
                                              : Text(
                                                  forMessageTypeString(
                                                          item.messageType,
                                                          content: item
                                                              .mediaChatMessage
                                                              ?.mediaCaptionText
                                                              .checkNull()) ??
                                                      item.messageTextContent
                                                          .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const AppDivider()
                            ],
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      controller.toChatPage(items.chatUserJid.checkNull());
                    },
                  );
                } else if (snap.hasError) {
                  mirrorFlyLog("snap error", snap.error.toString());
                }
                return const SizedBox();
              });
        });
  }

  ListView recentChatListView() {
    return ListView.builder(
        itemCount: controller.filteredRecentChatList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var item = controller.filteredRecentChatList[index];
          return FutureBuilder(
              future: getRecentChatOfJid(item.jid.checkNull()),
              builder: (context, snapshot) {
                var item = snapshot.data;
                return item != null
                    ? RecentChatItem(
                        item: item,
                        spanTxt: controller.search.text,
                        onTap: () {
                          controller.toChatPage(item.jid.checkNull());
                        },
                      )
                    : const SizedBox();
              });
        });
  }

  Widget emptyChat(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            noChatIcon,
            width: 200,
          ),
          Text(
            'No new messages',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Any new messages will appear here',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  //
  // @override
  // Widget build(BuildContext context) {
  //   return Obx(() {
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: const Text('HomeView'),
  //         centerTitle: true,
  //       ),
  //       body: Column(
  //         children: [
  //           Expanded(
  //             child: (controller.hasData.isFalse)
  //                 ? Center(
  //                     child: CircularProgressIndicator(),
  //                   )
  //                 : ListView.builder(
  //                     itemBuilder: (context, index) {
  //                       Profile profile = controller.userList[index];
  //                       return InkWell(
  //                         onTap: () {
  //                           controller.toChatPage(profile.jid!);
  //                         },
  //                         child: ListTile(
  //                           title: Text(profile.name!),
  //                           subtitle: Text(profile.email!),
  //                           leading: CircleAvatar(
  //                             child: Text(profile.image!),
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                     itemCount: controller.userList.length,
  //                   ),
  //           )
  //         ],
  //       ),
  //     );
  //   });
  // }
}

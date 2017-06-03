import 'package:flutter/foundation.dart';

import 'package:flutter_news/injection/dependency_injection.dart';
import 'package:flutter_news/model/hn_item.dart';

abstract class CommentsViewContract {
  void onCommentListUpdate();
}

class CommentsPresenter {
  CommentsViewContract _view;
  HnItemRepository _itemRepository;

  List<int> commentIdList;

  Map<int, int> _depthMap = <int, int>{};

  CommentsPresenter(this._view) {
    _itemRepository = new Injector().hnItemRepository;
  }

  void initList(List<int> commentList) {
    commentIdList = new List<int>.from(commentList);
    for (int commentId in commentIdList) {
      _depthMap.putIfAbsent(commentId, () => 0);
    }
  }

  void insertComments(int parentId, List<int> kidList) {
    assert(_view != null);

    final parentIndex = commentIdList.indexOf(parentId);

    if (parentIndex == -1) {
      debugPrint("Cannot find comment id $parentId");
      return;
    }

    // Infer comment depth level
    if (_depthMap.containsKey(parentId)) {
      final int parentDepthLevel = _depthMap[parentId];
      _itemRepository.setDepthLevel(parentId, parentDepthLevel);
      for (int kidId in kidList) {
        // Since kids are not loaded yet, we cannot update depth level
        // in repository. We will use temporary storage in map for now.
        print('id:$kidId, depth: ${parentDepthLevel + 1}');
        _depthMap.putIfAbsent(kidId, () => parentDepthLevel + 1);
      }
    }

    if (kidList.isEmpty) return;

    if (parentIndex == commentIdList.length) {
      // Parent is at the end of list, adding kids after it
      commentIdList.addAll(kidList);
    } else {
      if (commentIdList[parentIndex + 1] != kidList[0]) {
        // Comment kids were not inserted yet, inserting now
        commentIdList.insertAll(parentIndex + 1, kidList);
      } else {
        // Kids already added, no need to update view
        return;
      }
    }

    // Force rebuild, this will trigger loading of newly added ids
    _view.onCommentListUpdate();
  }
}

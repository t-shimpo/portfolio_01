$(function () {
  $(document).on("click", ".js-edit-comment-button", function () {
    const commentId = $(this).data('comment-id');
    const commentLabelArea = $('#js-comment-label-' + commentId);
    const commentTextArea = $('#js-textarea-comment-' + commentId);
    const commentButton = $('#js-comment-button-' + commentId);

    commentLabelArea.hide();
    commentTextArea.show();
    commentButton.show();
  });
});

// コメント編集エリア非表示
$(function () {
  $(document).on("click", ".comment-cancel-button", function () {
    const commentId = $(this).data('cancel-id');
    const commentLabelArea = $('#js-comment-label-' + commentId);
    const commentTextArea = $('#js-textarea-comment-' + commentId);
    const commentButton = $('#js-comment-button-' + commentId);
    const commentError = $('#js-comment-post-error-' + commentId);

    commentLabelArea.show();
    commentTextArea.hide();
    commentButton.hide();
    commentError.hide();
  });
});

// コメント更新ボタン
$(function () {
  $(document).on("click", ".comment-update-button", function () {
    const commentId = $(this).data('update-id');
    const textField = $('#js-textarea-comment-' + commentId);
    const commentContent = textField.val();
    const postId = $('.post_id_for_comment').val();
    const userId = $('.user_id_for_comment').val();
    console.log(commentContent);
    console.log(postId);
    console.log(userId);

    $.ajax({
      url: '/posts/' + postId +'/comments/' + commentId,
      type: 'PATCH',
      data: {
        comment: {
          comment_content: commentContent,
        }
      }
    })
      .done(function (data) {
        const commentLabelArea = $('#js-comment-label-' + commentId);
        const commentTextArea = $('#js-textarea-comment-' + commentId);
        const commentButton = $('#js-comment-button-' + commentId);
        const commentError = $('#js-comment-post-error-' + commentId);

        commentLabelArea.show();
        commentLabelArea.text(data.comment_content);
        commentTextArea.hide();
        commentButton.hide();
        commentError.hide();
      })
      .fail(function () {
        const commentError = $('#js-comment-post-error-' + commentId);
        commentError.show();
        commentError.text('コメントをは1文字以上150文字以内で入力してください');
      })
  });
});
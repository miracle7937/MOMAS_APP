class CommentResponse {
  bool? status;
  List<Comment>? comment;

  CommentResponse({this.status, this.comment});

  CommentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['comment'] != null) {
      comment = <Comment>[];
      json['comment'].forEach((v) {
        comment!.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (comment != null) {
      data['comment'] = comment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comment {
  int? id;
  int? userId;
  String? userName;
  int? count;
  String? comment;
  int? jobId;
  String? createdAt;
  int? rate;
  String? updatedAt;

  Comment(
      {this.id,
      this.userId,
      this.userName,
      this.count,
      this.comment,
      this.jobId,
      this.createdAt,
      this.updatedAt,
      this.rate});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    count = json['count'];
    comment = json['comment'];
    jobId = json['job_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['count'] = count;
    data['comment'] = comment;
    data['job_id'] = jobId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['rate'] = rate;
    return data;
  }
}

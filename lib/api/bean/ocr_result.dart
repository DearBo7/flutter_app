class OcrResultEntity {
  int logId;
  int wordsResultNum;
  List<WordsResultEntity> wordsResult;

  OcrResultEntity({this.logId, this.wordsResultNum, this.wordsResult});

  OcrResultEntity.fromJson(Map<String, dynamic> json) {
    logId = json['log_id'];
    wordsResultNum = json['words_result_num'] ?? 0;
    if (json['words_result'] != null) {
      wordsResult = new List<WordsResultEntity>();
      json['words_result'].forEach((v) {
        wordsResult.add(new WordsResultEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['log_id'] = this.logId;
    data['words_result_num'] = this.wordsResultNum;
    if (this.wordsResult != null) {
      data['words_result'] = this.wordsResult.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WordsResultEntity {
  String words;

  WordsResultEntity({this.words});

  WordsResultEntity.fromJson(Map<String, dynamic> json) {
    words = json['words'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['words'] = this.words;
    return data;
  }
}

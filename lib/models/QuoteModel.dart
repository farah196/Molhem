
class QuoteModel
{

  String id ;
  String quote ;
  String said ;

  QuoteModel({
    this.id,
    this.quote,
    this.said,
  });

  factory QuoteModel.fromMap(Map<String, dynamic> json) => new QuoteModel(
    id: json["id"],
    quote: json["quote"],
    said: json["said"],
  );

}
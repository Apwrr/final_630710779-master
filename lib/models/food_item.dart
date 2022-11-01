class FootBall{
  final int id;
  final String team;
  final String group;
  final String flagImage;
  final int orderCount = 0;

  FootBall({
    required this.id,
    required this.team,
    required this.group,
    required this.flagImage,
  });
  factory FootBall.formJson(Map<String, dynamic> json){
    return FootBall(
        id: json['id'],
        team: json['team'],
        group: json['group'],
      flagImage: json['flagImage'],
    );
  }
}
import 'package:flutter_se_test/model/channel.dart';

class ChannelResponse{

  final Channel channel;

  ChannelResponse({this.channel});

  factory ChannelResponse.fromJson(Map<String, dynamic> json){
    return ChannelResponse(
      channel: Channel.fromJson(json['channel'])
    );
  }

}
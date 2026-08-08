import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';

class PlayerPage extends StatefulWidget {
  final CartoonModel cartoon;
  const PlayerPage({super.key, required this.cartoon});
  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool showControls = true;
  @override
  void initState() { super.initState(); Future.delayed(Duration(seconds:3), ()=> setState(()=>showControls=false)); }

  @override
  Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(
    backgroundColor: Colors.black,
    body: GestureDetector(onTap:()=>setState(()=>showControls=!showControls), child:Stack(alignment:Alignment.center,fit:StackFit.expand,children:[
      Image.network(widget.cartoon.thumbnailUrl,fit:BoxFit.cover,width:double.infinity,errorBuilder:(_,__,___)=>Container(color:Colors.black)),
      if(showControls)...[
        Positioned(top:40,left:16,right:16,child:Row(children:[IconButton(icon:Icon(Icons.arrow_back_ios_new,color:Colors.white),onPressed:()=>Navigator.pop(context))])),
        Center(child:CircleAvatar(radius:35,backgroundColor:Colors.white24,child:Icon(Icons.play_arrow,color:Colors.white,size:50))),
        Positioned(bottom:0,left:0,right:0,child:Container(padding:EdgeInsets.symmetric(horizontal:20,vertical:20),color:Colors.black38,child:Column(mainAxisSize:MainAxisSize.min,children:[
          Slider(value:0.3,onChanged:(v){},activeColor:AppTheme.primary,inactiveColor:Colors.grey),
          Row(children:[Icon(Icons.skip_previous,color:Colors.white),Icon(Icons.pause_circle_filled,size:35,color:Colors.white),Icon(Icons.skip_next,color:Colors.white)])
        ])))
      ]
    ]))
  ));
}

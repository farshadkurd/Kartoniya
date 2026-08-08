import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';
import 'player_page.dart';

class CartoonDetailPage extends StatelessWidget {
  final CartoonModel cartoon;
  const CartoonDetailPage({super.key, required this.cartoon});

  @override
  Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(body: CustomScrollView(slivers: [
    SliverAppBar(expandedHeight:280,pinned:true,backgroundColor:AppTheme.background,flexibleSpace:FlexibleSpaceBar(background:Stack(fit:StackFit.expand,children:[
      CachedNetworkImage(imageUrl:cartoon.thumbnailUrl,fit:BoxFit.cover),
      DecoratedBox(position:DecorationPosition.foreground,decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Colors.transparent,AppTheme.background])))
    ]))),
    SliverToBoxAdapter(child:Padding(padding:EdgeInsets.all(24),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(cartoon.title,style:Theme.of(context).textTheme.displayLarge!.copyWith(fontSize:28)),
      SizedBox(height:10),
      Row(children:[StarIcon(),SizedBox(width:5),Text("4.8 | ${cartoon.duration} min")]),
      SizedBox(height:20),
      InkWell(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>PlayerPage(cartoon:cartoon))),borderRadius:BorderRadius.circular(20),child:Container(height:60,decoration:BoxDecoration(gradient:LinearGradient(colors:[AppTheme.primary,AppTheme.primaryDark]),borderRadius:BorderRadius.circular(20)),child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.play_circle,color:Colors.white,size:30),SizedBox(width:10),Text("پخش ویدیو",style:TextStyle(color:Colors.white,fontWeight:Bold,fontSize:18))])))
    ])))
  ])));
}

class StarIcon extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) => Row(mainAxisSize:MainAxisSize.min,children:[Icon(Icons.star,color:AppTheme.goldGlow,size:20)]);
}

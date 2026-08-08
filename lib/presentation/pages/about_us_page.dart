import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});
  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> with SingleTickerProviderStateMixin {
  late AnimationController glowCtrl, rotCtrl;

  @override
  void initState() {
    super.initState();
    glowCtrl = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat(reverse: true);
    rotCtrl = AnimationController(vsync: this, duration: Duration(seconds: 10))..repeat();
  }
  @override void dispose(){glowCtrl.dispose();rotCtrl.dispose();super.dispose();}

  @override
  Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(
    backgroundColor: AppTheme.background,
    body: SafeArea(child: SingleChildScrollView(physics:BouncingScrollPhysics(), padding:EdgeInsets.all(24), child:Column(children:[
      SizedBox(height:30),
      AnimatedBuilder(animation: Listenable.merge([glowCtrl, rotCtrl]), builder: (_, __){
        double o = 0.4 + (glowCtrl.value * 0.6);
        return Transform.rotate(angle: rotCtrl.value * 2 * math.pi, child: Container(width:180,height:180, child:Stack(alignment:Alignment.center,children:[
          Container(width:170,height:170,decoration:BoxDecoration(shape:BoxShape.circle,boxShadow:[BoxShadow(color:AppTheme.goldGlow.withOpacity(o*0.4),blurRadius:40+(20*glowCtrl.value)]))),
          CustomPaint(size:Size(160,160), painter:GoldenRingPainter(val:rotCtrl.value)),
          Container(width:150,height:150,decoration:BoxDecoration(color:AppTheme.background,shape:BoxShape.circle), child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
            Icon(Icons.verified_user,size:50,color:AppTheme.primaryDark),
            SizedBox(height:8), Text("Parsa Apps", style:TextStyle(color:AppTheme.textMain,fontWeight:Bold))
          ]))
        ])));
      }),
      SizedBox(height:40),
      ShaderMask(shaderCallback:(b)=>LinearGradient(colors:[Colors.orange[800]!,AppTheme.goldGlow,Colors.orange[800]]).createShader(b), child: Text("فرشاد پارسا",style:TextStyle(fontSize:28,fontWeight:FontWeight.w900,color:Colors.white))),
      SizedBox(height:10), Text("توسعه‌دهنده نسل آینده", style:Theme.of(context).textTheme.bodyLarge),
      SizedBox(height:30),
      _buildTile(Icons.send, Color(0xFF0088cc), "تلگرام", "@Parsaappsadmin", "https://t.me/Parsaappsadmin"),
      SizedBox(height:15),
      _buildTile(Icons.language, Colors.deepPurple, "وبسایت", "www.parsa-apps.com", "")
    ]))))
  ));

  Widget _buildTile(IconData icon, Color col, String t, String s, String url) => InkWell(onTap: url.isNotEmpty? ()async{if(await canLaunchUrl(Uri.parse(url)))launchUrl(url);} :null , borderRadius:BorderRadius.circular(20), child:Container(padding:EdgeInsets.all(16),decoration:BoxDecoration(color:AppTheme.surface,borderRadius:BorderRadius.circular(20)),child:Row(children:[
    Container(padding:EdgeInsets.all(10),decoration:BoxDecoration(color:col,shape:BoxShape.circle),child:Icon(icon,color:Colors.white)),
    SizedBox(width:16), Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(t,style:TextStyle(fontWeight:Bold)),Text(s,style:TextStyle(color:AppTheme.textSub))]), Spacer(), Icon(Icons.arrow_back_ios_new, size:14, color:Colors.grey)
  ])));
}

class GoldenRingPainter extends CustomPainter{
  final double val;
  GoldenRingPainter({required this.val});
  @override void paint(Canvas c, Size s){c.drawCircle(s.center(Offset.zero),s.width/2,Paint()..strokeWidth=4..style=PaintingStyle.stroke..shader=SweepGradient(startAngle:-math.pi/2+(val*2*math.pi),endAngle:3*math.pi/2+(val*2*math.pi),colors:[Colors.transparent,AppTheme.goldGlow,Colors.transparent]).createShader(Offset.zero&s));}
  @override bool shouldRepaint(covariant CustomPainter o)=>true;
}

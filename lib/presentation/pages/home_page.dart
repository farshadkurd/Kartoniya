import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/cartoons_provider.dart';
import '../widgets/shimmer_loader.dart';
import 'about_us_page.dart';
import 'cartoon_detail_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartoonsAsync = ref.watch(cartoonsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(title: Text("🌟 کارتون‌های جدید"), actions: [
          IconButton(icon: Icon(Icons.info_outline), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUsPage())))
        ]),
        body: Padding(padding: EdgeInsets.all(16), child: Column(children: [
          Container(margin: EdgeInsets.only(bottom: 20), child: TextField(readOnly: true, decoration: InputDecoration(hintText: 'جستجو...', prefixIcon: Icon(Icons.search, color: AppTheme.primary)))),
          
          Expanded(child: cartoonsAsync.when(data: (list) => GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 24, childAspectRatio: 0.85), itemCount: list.length, itemBuilder: (ctx, idx) => _buildCard(context, list[idx])),
            loading: () => GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 24, childAspectRatio: 0.85), itemCount: 6, itemBuilder: (_,__) => ShimmerCard()),
            error: (e,s) => Center(child: Text("خطا")))
          )
        ]))
      )
    );
  }

  Widget _buildCard(ctx, model) => GestureDetector(
    onTap: (){
      HapticFeedback.lightImpact();
      Navigator.push(ctx, MaterialPageRoute(builder: (_) => CartoonDetailPage(cartoon: model)));
    },
    child: Container(decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(25)), clipBehavior: Clip.antiAlias, child: Column(children: [
      Expanded(flex: 3, child: Stack(fit: StackFit.expand, children: [
        CachedNetworkImage(imageUrl: model.thumbnailUrl, fit: BoxFit.cover),
        if(model.isNew) Positioned(top:10, left:10, child: Container(padding:EdgeInsets.symmetric(horizontal:8,vertical:4), decoration:BoxDecoration(color:Colors.redAccent,borderRadius:BorderRadius.circular(20)), child:Text("جدید",style:TextStyle(color:Colors.white,fontSize:10))))
      ])),
      Expanded(flex: 2, child: Padding(padding:EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(model.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
        Row(children: [Icon(Icons.access_time, size:14, color:AppTheme.textSub), SizedBox(width:4), Text("${model.duration} دقیقه", style: TextStyle(fontSize:12))])
      ])))
    ]))
  );
}

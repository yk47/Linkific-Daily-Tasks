import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../models/quote_model.dart';
import '../theme/app_theme.dart';



class QuoteCard extends StatelessWidget {

  final QuoteModel quote;
  final FavoriteController favoriteController;


  const QuoteCard({
    super.key,
    required this.quote,
    required this.favoriteController,
  });



  @override
  Widget build(BuildContext context) {


    final quoteText = quote.quote;
    final author = quote.author;



    return Container(

      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.divider,
        ),
      ),



      child: Padding(

        padding: const EdgeInsets.all(20),


        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [


            Text(
              quoteText,

              maxLines: 5,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontFamily:'Georgia',
                fontSize:15.5,
                height:1.7,
                fontStyle:FontStyle.italic,
                color:AppTheme.textPrimary,
              ),
            ),



            const SizedBox(height:16),



            Row(

              children: [



                Flexible(

                  child: Row(

                    children: [


                      Container(
                        width:16,
                        height:1.5,
                        color:AppTheme.accent,
                      ),


                      const SizedBox(width:8),



                      Flexible(

                        child: Text(

                          author,

                          maxLines:1,
                          overflow:
                          TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize:12,
                            color:AppTheme.accent,
                            fontWeight:
                            FontWeight.w600,
                          ),

                        ),

                      )


                    ],

                  ),

                ),




                _CopyButton(
                  quoteText: quoteText,
                  author: author,
                ),



                const SizedBox(width:5),



                _FavoriteButton(
                  quote: quote,
                  favoriteController:
                  favoriteController,
                )


              ],

            )

          ],

        ),

      ),

    );

  }

}





class _CopyButton extends StatefulWidget {


  final String quoteText;
  final String author;



  const _CopyButton({
    required this.quoteText,
    required this.author,
  });



  @override
  State<_CopyButton> createState()
  => _CopyButtonState();

}




class _CopyButtonState extends State<_CopyButton>{


  bool copied=false;



  Future<void> copy() async{


    await Clipboard.setData(

      ClipboardData(
        text:
        '"${widget.quoteText}" — ${widget.author}',
      ),

    );



    setState(() {
      copied=true;
    });



    await Future.delayed(
      const Duration(seconds:2),
    );



    if(mounted){

      setState(() {
        copied=false;
      });

    }

  }





  @override
  Widget build(BuildContext context){


    return GestureDetector(

      onTap:copy,


      child:Icon(

        copied
        ? Icons.check
        : Icons.copy,

        size:16,

      ),

    );

  }

}







class _FavoriteButton extends StatelessWidget {


  final QuoteModel quote;
  final FavoriteController favoriteController;



  const _FavoriteButton({
    required this.quote,
    required this.favoriteController,
  });



  @override
  Widget build(BuildContext context){


    return Obx(() {


      final isFav =
      favoriteController.isFavorite(quote);



      return GestureDetector(

        onTap:(){

          if(isFav){

            favoriteController
            .removeFavoriteByQuote(quote);

          }
          else{

            favoriteController
            .addFavorite(quote);

          }

        },



        child:Icon(

          isFav
          ? Icons.favorite
          : Icons.favorite_border,


          color:
          isFav
          ? AppTheme.accent
          : AppTheme.textSecondary,


          size:18,

        ),

      );

    });

  }

}
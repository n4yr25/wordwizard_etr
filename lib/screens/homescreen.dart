import 'package:flutter/material.dart';
import 'package:wordwizard_mad_etr/models/api.dart';
import 'package:wordwizard_mad_etr/components/drawer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:wordwizard_mad_etr/models/response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  stt.SpeechToText? speech;
  var sttCont = TextEditingController();
  bool isListening = false;
  bool inProgress = false;
  ResponseModel? responseModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    speech = stt.SpeechToText();
    sttCont.text;
  }

  void startListening() async {
    sttCont.clear();
    if (!isListening) {
      bool available = await speech!.initialize(
        onStatus: (status) {
          print("status: ${status}");
        },
        onError: (errorNotification) {
          print(errorNotification);
        },
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        speech!.listen(
          onResult: (result) {
            setState(() {
              sttCont.text = result.recognizedWords;
            });
          },
        );
      }
    }
  }

  void stopListening() {
    // getMeaning(value);
    if (isListening) {
      speech!.stop();
      setState(() {
        isListening = false;
      });
    }
  }

  void getMeaning(String word) async {
    responseModel = await API.fetchMeaning(word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Image.asset(
            "assets/icons/ww_logo.png",
            height: 40,
          ),
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: DrawerTab(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: sttCont,
                autofocus: false,
                style: TextStyle(
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  hintText: "Search Word Here",
                  hintStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    onLongPress: startListening,
                    onLongPressUp: stopListening,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.mic_outlined,
                        color: Colors.black,
                        size: isListening ? 40 : 30,
                      ),
                    ),
                  ),
                ),
                onEditingComplete: () {
                  setState(() {
                    getMeaning(sttCont.text);
                  });
                  print("tapped: ${sttCont.text}");
                },
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  getMeaning(sttCont.text);
                  setState(() {});
                  print("tapped: ${sttCont.text}");
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * .6,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "GO",
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 5,
              ),
              Text("${responseModel?.word ?? ""}"),
              Text(responseModel?.phonetic ?? ""),
              if (responseModel?.meanings != null)
                ...responseModel!.meanings!.map(
                  (meaning) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${meaning.partOfSpeech ?? ""}:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (meaning.definitions != null)
                        ...meaning.definitions!.map(
                          (definition) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '- ${definition.definition ?? "N/A"}',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              if (definition.example != null)
                                Text(
                                  '  Example: ${definition.example}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey),
                                ),
                              if (definition.synonyms != null)
                                Text(
                                  '  Synonyms: ${meaning.synonyms!.join(", ")}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey),
                                ),
                              if (definition.antonyms != null)
                                Text(
                                  '  Antonyms: ${meaning.antonyms!.join(", ")}',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              // ListView.builder(
              //   itemCount: responseModel!.meanings!.length,
              //   itemBuilder: (context, index) {
              //     List<Definitions> meanings = responseModel!
              //         .meanings![index].definitions!
              //         .map((element) =>
              //             Definitions(definition: element.definition))
              //         .toList();
              //     return Text(meanings.toString());
              //   },
              // )
              // Expanded(
              //   child: FutureBuilder<List<Meanings>>(
              //     future: API.fetchMeaning(sttCont.text).then((response) {
              //       // Assuming response.data contains the list of meanings
              //       List<Meanings> meanings = response.meanings!.toList();
              //       return meanings;
              //     }),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(child: CircularProgressIndicator());
              //       }
              //       if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //         return Center(child: Text("No Meaning"));
              //       }
              //       List<Meanings> meanings = snapshot.data!;

              //       return ListView.builder(
              //         itemCount: meanings.length,
              //         itemBuilder: (context, index) {
              //           List<Definitions> definitions =
              //               meanings[index].definitions ?? [];
              //           return Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 "Meaning ${index + 1}:",
              //                 style: TextStyle(fontWeight: FontWeight.bold),
              //               ),
              //               SizedBox(height: 4),
              //               // Display each definition
              //               ...definitions.map((definition) {
              //                 return Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       "Part of Speech: ${definition.antonyms}",
              //                       style: TextStyle(fontWeight: FontWeight.bold),
              //                     ),
              //                     SizedBox(height: 4),
              //                     Text(definition.definition!),
              //                     SizedBox(height: 8),
              //                     SizedBox(height: 4),
              //                     Text(definition.definition!),
              //                     SizedBox(height: 8),
              //                   ],
              //                 );
              //               }),
              //             ],
              //           );
              //         },
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

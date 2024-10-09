import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
class Finalverdict extends StatefulWidget {
  const Finalverdict({super.key});
  @override
  _FinalverdictState createState() => _FinalverdictState();
}
class _FinalverdictState extends State<Finalverdict> {
  String? _verdict;
  bool _isOtherSelected = false;
  final TextEditingController _customVerdictController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    _customVerdictController.addListener(_updateSubmitButtonState);
  }
  @override
  void dispose() {
    _customVerdictController.removeListener(_updateSubmitButtonState);
    _customVerdictController.dispose();
    super.dispose();
  }
  void _updateSubmitButtonState() {
    setState(() {});
  }
  void _generatePdf() async {
    final pdf = pw.Document();

    final finalVerdict =
        _isOtherSelected ? _customVerdictController.text : _verdict;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Final Verdict Report',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Verdict: $finalVerdict',
                  style: const pw.TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Display the generated PDF document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Final Verdict'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4568DC), Color(0xFFB06AB3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Final Verdict:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Pass'),
                leading: Radio<String>(
                  value: 'Pass',
                  groupValue: _verdict,
                  onChanged: (value) {
                    setState(() {
                      _verdict = value;
                      _isOtherSelected = false;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Fail'),
                leading: Radio<String>(
                  value: 'Fail',
                  groupValue: _verdict,
                  onChanged: (value) {
                    setState(() {
                      _verdict = value;
                      _isOtherSelected = false;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Need to Review Again'),
                leading: Radio<String>(
                  value: 'Need to Review Again',
                  groupValue: _verdict,
                  onChanged: (value) {
                    setState(() {
                      _verdict = value;
                      _isOtherSelected = false;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Other'),
                leading: Radio<String>(
                  value: 'Other',
                  groupValue: _verdict,
                  onChanged: (value) {
                    setState(() {
                      _verdict = value;
                      _isOtherSelected = true;
                    });
                  },
                ),
              ),
              if (_isOtherSelected)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    controller: _customVerdictController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your verdict',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (_verdict != null &&
                        (_verdict != 'Other' ||
                            _customVerdictController.text.isNotEmpty))
                    ? _generatePdf
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_verdict != null &&
                          (_verdict != 'Other' ||
                              _customVerdictController.text.isNotEmpty))
                      ? const Color(0xFF7B42F6)
                      : Colors.grey,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

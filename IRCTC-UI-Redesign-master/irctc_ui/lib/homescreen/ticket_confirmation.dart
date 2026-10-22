import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:irctc_ui/homescreen/homepage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TicketConfirmationScreen extends StatefulWidget {
  final String trainName;
  final String trainNumber;
  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final String travelDate;
  final String className;
  final String quota;
  final List<Map<String, String>> passengers;
  final List<String> selectedSeats;
  final String pnrNumber;

  const TicketConfirmationScreen({
    super.key,
    required this.trainName,
    required this.trainNumber,
    required this.fromCode,
    required this.fromName,
    required this.toCode,
    required this.toName,
    required this.travelDate,
    required this.className,
    required this.quota,
    required this.passengers,
    required this.selectedSeats,
    required this.pnrNumber,
  });

  @override
  State<TicketConfirmationScreen> createState() =>
      _TicketConfirmationScreenState();
}

class _TicketConfirmationScreenState extends State<TicketConfirmationScreen>
    with TickerProviderStateMixin {
  late final AnimationController entranceController;
  late final AnimationController shimmerController;

  bool isDownloading = false;
  Offset ticketTilt = Offset.zero;

  double get totalFare => widget.selectedSeats.length * 485.0;

  String get transactionId =>
      'IRCTC${widget.pnrNumber.replaceAll(RegExp(r'[^0-9]'), '')}';

  @override
  void initState() {
    super.initState();
    entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    entranceController.dispose();
    shimmerController.dispose();
    super.dispose();
  }

  String seatFor(int index) {
    if (index < widget.passengers.length) {
      final seat = widget.passengers[index]['seat'];
      if (seat != null && seat.isNotEmpty) return seat;
    }
    if (index < widget.selectedSeats.length) {
      return widget.selectedSeats[index];
    }
    return '-';
  }

  // ---------------- PDF ----------------

  Future<Uint8List> buildTicketPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (_) => [
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.grey600,
                width: 1,
              ),
            ),
            child: pw.Column(
              children: [
                _pdfHeader(),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(14),
                  child: pw.Column(
                    children: [
                      _pdfPnrRow(),
                      pw.SizedBox(height: 12),
                      pw.Divider(color: PdfColors.grey400),
                      pw.SizedBox(height: 10),
                      _pdfRoute(),
                      pw.SizedBox(height: 12),
                      _pdfTravelDetails(),
                      pw.SizedBox(height: 16),
                      _pdfTitle('PASSENGER DETAILS'),
                      pw.SizedBox(height: 7),
                      _pdfPassengerTable(),
                      pw.SizedBox(height: 15),
                      _pdfTitle('FARE DETAILS'),
                      pw.SizedBox(height: 7),
                      _pdfFareBox(),
                      pw.SizedBox(height: 14),
                      _pdfTransaction(),
                    ],
                  ),
                ),
                _pdfImportantInfo(),
              ],
            ),
          ),
          pw.SizedBox(height: 7),
          pw.Center(
            child: pw.Text(
              'DEMO / UI PROJECT TICKET • NOT A VALID TRAVEL DOCUMENT',
              style: const pw.TextStyle(
                fontSize: 7,
                color: PdfColors.grey600,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _pdfHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      color: PdfColors.blue900,
      child: pw.Row(
        children: [
          pw.Container(
            width: 42,
            height: 42,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(7),
            ),
            child: pw.Center(
              child: pw.Text(
                'IR',
                style: const pw.TextStyle(
                  color: PdfColors.blue900,
                  fontSize: 17,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'INDIAN RAILWAYS',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Electronic Reservation Slip',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: pw.BoxDecoration(
              color: PdfColors.green700,
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Text(
              'CONFIRMED',
              style: const pw.TextStyle(
                color: PdfColors.white,
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfPnrRow() {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _pdfLabel('PNR NUMBER'),
              pw.SizedBox(height: 3),
              pw.Text(
                widget.pnrNumber,
                style: const pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            _pdfLabel('BOOKING STATUS'),
            pw.SizedBox(height: 3),
            pw.Text(
              'BOOKING CONFIRMED',
              style: const pw.TextStyle(
                fontSize: 9,
                color: PdfColors.green700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _pdfRoute() {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _pdfStation(
            widget.fromCode,
            widget.fromName,
            'BOARDING',
          ),
        ),
        pw.SizedBox(width: 15),
        pw.Column(
          children: [
            _pdfLabel('JOURNEY'),
            pw.SizedBox(height: 3),
            pw.Text(
              '→',
              style: const pw.TextStyle(
                fontSize: 22,
                color: PdfColors.blue900,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(width: 15),
        pw.Expanded(
          child: _pdfStation(
            widget.toCode,
            widget.toName,
            'DESTINATION',
            right: true,
          ),
        ),
      ],
    );
  }

  pw.Widget _pdfStation(
    String code,
    String name,
    String label, {
    bool right = false,
  }) {
    return pw.Column(
      crossAxisAlignment:
          right ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
      children: [
        _pdfLabel(label),
        pw.SizedBox(height: 3),
        pw.Text(
          code,
          style: const pw.TextStyle(
            fontSize: 20,
            color: PdfColors.blue900,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          name,
          textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
          style: const pw.TextStyle(fontSize: 7.5),
        ),
      ],
    );
  }

  pw.Widget _pdfTravelDetails() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(9),
      color: PdfColors.grey100,
      child: pw.Row(
        children: [
          _pdfDetail('TRAIN', widget.trainNumber),
          _pdfDetail('DATE', widget.travelDate),
          _pdfDetail('CLASS', widget.className),
          _pdfDetail('QUOTA', widget.quota),
        ],
      ),
    );
  }

  pw.Widget _pdfDetail(String label, String value) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          _pdfLabel(label),
          pw.SizedBox(height: 3),
          pw.Text(
            value,
            maxLines: 1,
            style: const pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      color: PdfColors.blue900,
      child: pw.Text(
        title,
        style: const pw.TextStyle(
          color: PdfColors.white,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _pdfLabel(String value) {
    return pw.Text(
      value,
      style: const pw.TextStyle(
        fontSize: 6,
        color: PdfColors.grey600,
        fontWeight: pw.FontWeight.bold,
      ),
    );
  }

  pw.Widget _pdfPassengerTable() {
    final rows = <pw.TableRow>[
      pw.TableRow(
        decoration: const pw.BoxDecoration(
          color: PdfColors.grey200,
        ),
        children: [
          'S.No.',
          'Passenger',
          'Age',
          'Gender',
          'Berth',
          'Seat',
          'Status',
        ].map(_pdfCellHeader).toList(),
      ),
    ];

    for (int i = 0; i < widget.passengers.length; i++) {
      final p = widget.passengers[i];
      final values = [
        '${i + 1}',
        p['name'] ?? 'Passenger',
        p['age'] ?? '-',
        p['gender'] ?? '-',
        p['berth'] ?? '-',
        seatFor(i),
        'CNF',
      ];

      rows.add(
        pw.TableRow(
          children: values.map(_pdfCell).toList(),
        ),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(
        color: PdfColors.grey400,
        width: .6,
      ),
      children: rows,
    );
  }

  pw.Widget _pdfCellHeader(String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        value,
        style: const pw.TextStyle(
          fontSize: 6.5,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _pdfCell(String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        value,
        style: const pw.TextStyle(fontSize: 7),
      ),
    );
  }

  pw.Widget _pdfFareBox() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        children: [
          _pdfFareRow(
            'Base Fare',
            '₹${(totalFare * .90).toStringAsFixed(2)}',
          ),
          _pdfFareRow(
            'Reservation / Service Charges',
            '₹${(totalFare * .06).toStringAsFixed(2)}',
          ),
          _pdfFareRow(
            'GST / Other Charges',
            '₹${(totalFare * .04).toStringAsFixed(2)}',
          ),
          pw.Divider(color: PdfColors.grey400),
          _pdfFareRow(
            'TOTAL FARE',
            '₹${totalFare.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfFareRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight:
                    bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight:
                  bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfTransaction() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _pdfLabel('TRANSACTION ID'),
              pw.SizedBox(height: 3),
              pw.Text(
                transactionId,
                style: const pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              _pdfLabel('BOOKING DATE'),
              pw.SizedBox(height: 3),
              pw.Text(
                _bookingDate(),
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                widget.trainName,
                maxLines: 1,
                style: const pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 12),
        pw.Container(
          width: 125,
          height: 65,
          padding: const pw.EdgeInsets.all(5),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey500),
          ),
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.code128(),
            data: widget.pnrNumber,
            drawText: true,
            textStyle: const pw.TextStyle(fontSize: 7),
          ),
        ),
      ],
    );
  }

  pw.Widget _pdfImportantInfo() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(9),
      color: PdfColors.grey100,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'IMPORTANT INFORMATION',
            style: const pw.TextStyle(
              fontSize: 7,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Carry a valid government photo ID during the journey. '
            'Please verify the final reservation status and journey '
            'details before travel.',
            style: const pw.TextStyle(
              fontSize: 6.8,
              color: PdfColors.grey800,
            ),
          ),
        ],
      ),
    );
  }

  String _bookingDate() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(now.day)}-${two(now.month)}-${now.year} '
        '${two(now.hour)}:${two(now.minute)}';
  }

  // ---------------- DOWNLOAD / SHARE ----------------

  Future<void> downloadTicket() async {
    setState(() => isDownloading = true);

    try {
      final bytes = await buildTicketPdf();
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/IRCTC_Ticket_${widget.pnrNumber}.pdf';

      await File(path).writeAsBytes(bytes);

      if (!mounted) return;
      setState(() => isDownloading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('E-ticket PDF saved successfully.'),
          action: SnackBarAction(
            label: 'SHARE',
            onPressed: () {
              Printing.sharePdf(
                bytes: bytes,
                filename: 'IRCTC_Ticket_${widget.pnrNumber}.pdf',
              );
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isDownloading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save ticket: $e')),
      );
    }
  }

  Future<void> shareTicket() async {
    try {
      final bytes = await buildTicketPdf();
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'IRCTC_Ticket_${widget.pnrNumber}.pdf',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not share ticket: $e')),
      );
    }
  }

  void goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (_) => false,
    );
  }

  // ---------------- SCREEN ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03060B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF03060B),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Your E-Ticket',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: shareTicket,
            icon: const Icon(
              Icons.share_rounded,
              color: Color(0xFF6AA8FF),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: CurvedAnimation(
          parent: entranceController,
          curve: Curves.easeOut,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 30),
          children: [
            _confirmationHeader(),
            const SizedBox(height: 18),
            _interactiveTicket(),
            const SizedBox(height: 16),
            _digitalTicket(),
            const SizedBox(height: 16),
            _actions(),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: goHome,
              icon: const Icon(
                Icons.home_outlined,
                color: Color(0xFF63A0FF),
              ),
              label: const Text(
                'Back to Home',
                style: TextStyle(
                  color: Color(0xFF63A0FF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _confirmationHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF102744),
            Color(0xFF09101B),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF2384FF).withValues(alpha: .25),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1677FF).withValues(alpha: .10),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.greenAccent.withValues(alpha: .09),
              border: Border.all(
                color: Colors.greenAccent.withValues(alpha: .35),
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.greenAccent,
              size: 40,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Booking Confirmed',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your railway e-ticket is ready',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const Text(
                  'PNR NUMBER',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 8,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.pnrNumber,
                  style: const TextStyle(
                    color: Color(0xFF73B1FF),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _interactiveTicket() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          ticketTilt = Offset(
            (ticketTilt.dx + details.delta.dx * .35).clamp(-8.0, 8.0),
            (ticketTilt.dy + details.delta.dy * .35).clamp(-6.0, 6.0),
          );
        });
      },
      onPanEnd: (_) => setState(() => ticketTilt = Offset.zero),
      child: AnimatedBuilder(
        animation: shimmerController,
        builder: (context, child) {
          final shimmerX = -1.3 + shimmerController.value * 2.6;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, .001)
              ..rotateX(ticketTilt.dy * math.pi / 180)
              ..rotateY(-ticketTilt.dx * math.pi / 180),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .78),
                        blurRadius: 35,
                        spreadRadius: 3,
                        offset: const Offset(0, 20),
                      ),
                      BoxShadow(
                        color: const Color(0xFF1976FF).withValues(alpha: .08),
                        blurRadius: 35,
                      ),
                    ],
                  ),
                  child: ClipPath(
                    clipper: TicketPaperClipper(),
                    child: Container(
                      color: const Color(0xFFF7F9FC),
                      child: Column(
                        children: [
                          _ticketTop(),
                          _ticketJourney(),
                          const TicketPerforation(),
                          _ticketPassengers(),
                          _ticketFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: ClipPath(
                      clipper: TicketPaperClipper(),
                      child: CustomPaint(
                        painter: TicketShimmerPainter(
                          progress: shimmerX,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _ticketTop() {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 16, 17, 13),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0A4D9B),
            Color(0xFF126BC7),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'IR',
                style: TextStyle(
                  color: Color(0xFF0751A0),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INDIAN RAILWAYS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Electronic Reservation Slip',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 8.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Text(
              'CONFIRMED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ticketJourney() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 15, 17, 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _station(
                  widget.fromCode,
                  widget.fromName,
                  'BOARDING',
                  true,
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0A5EB8).withValues(alpha: .08),
                ),
                child: const Icon(
                  Icons.train_rounded,
                  color: Color(0xFF0757AA),
                  size: 22,
                ),
              ),
              Expanded(
                child: _station(
                  widget.toCode,
                  widget.toName,
                  'DESTINATION',
                  false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _ticketDetail('TRAIN', widget.trainNumber),
                _ticketDetail('DATE', widget.travelDate),
                _ticketDetail('CLASS', widget.className),
                _ticketDetail('QUOTA', widget.quota),
              ],
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              const Icon(
                Icons.train_outlined,
                size: 14,
                color: Color(0xFF24649A),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  widget.trainName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF263746),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'PNR ${widget.pnrNumber}',
                style: const TextStyle(
                  color: Color(0xFF567080),
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _station(
    String code,
    String name,
    String label,
    bool left,
  ) {
    return Column(
      crossAxisAlignment:
          left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF71818E),
            fontSize: 7,
            fontWeight: FontWeight.w800,
            letterSpacing: .5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          code,
          style: const TextStyle(
            color: Color(0xFF123F6A),
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: left ? TextAlign.left : TextAlign.right,
          style: const TextStyle(
            color: Color(0xFF536572),
            fontSize: 8,
          ),
        ),
      ],
    );
  }

  Widget _ticketDetail(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF82919D),
              fontSize: 6.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF263746),
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ticketPassengers() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 13, 17, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PASSENGER DETAILS',
            style: TextStyle(
              color: Color(0xFF184B78),
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 6,
            ),
            color: const Color(0xFFEAF1F7),
            child: const Row(
              children: [
                SizedBox(
                  width: 22,
                  child: Text(
                    'S.No.',
                    style: TextStyle(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Passenger',
                    style: TextStyle(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  width: 52,
                  child: Text(
                    'Age/G',
                    style: TextStyle(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: Text(
                    'Seat',
                    style: TextStyle(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  width: 43,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.passengers.isEmpty)
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Passenger details unavailable.',
                style: TextStyle(
                  color: Color(0xFF687984),
                  fontSize: 9,
                ),
              ),
            ),
          ...widget.passengers.asMap().entries.map(
            (entry) {
              final i = entry.key;
              final p = entry.value;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFDDE4EA),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 22,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: Color(0xFF405361),
                          fontSize: 7,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        p['name'] ?? 'Passenger',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF24343F),
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 52,
                      child: Text(
                        '${p['age'] ?? '-'} / ${p['gender'] ?? '-'}',
                        style: const TextStyle(
                          color: Color(0xFF596B78),
                          fontSize: 7,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      child: Text(
                        seatFor(i),
                        style: const TextStyle(
                          color: Color(0xFF174D7B),
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 43,
                      child: Text(
                        'CNF',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 7,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _ticketFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 11, 17, 14),
      color: const Color(0xFFF1F4F6),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: Color(0xFF315F80),
                size: 16,
              ),
              const SizedBox(width: 6),
              const Text(
                'Total Fare',
                style: TextStyle(
                  color: Color(0xFF455866),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '₹${totalFare.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF123F6A),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF72828E),
                size: 12,
              ),
              const SizedBox(width: 5),
              const Expanded(
                child: Text(
                  'Carry a valid photo ID during your journey.',
                  style: TextStyle(
                    color: Color(0xFF697984),
                    fontSize: 7,
                  ),
                ),
              ),
              Text(
                'DEMO TICKET',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _digitalTicket() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF0F151D),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: .07),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            height: 88,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
              ),
              child: CustomPaint(
                painter: FakeQrPainter(widget.pnrNumber),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Digital Ticket',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Show the digital ticket during your journey.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10.5,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: Colors.greenAccent,
                      size: 14,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Booking verified',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: isDownloading ? null : downloadTicket,
            icon: isDownloading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.picture_as_pdf_rounded),
            label: Text(
              isDownloading
                  ? 'Preparing Ticket PDF...'
                  : 'Download E-Ticket PDF',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1677F8),
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor:
                  const Color(0xFF1677F8).withValues(alpha: .30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: shareTicket,
            icon: const Icon(
              Icons.share_rounded,
              color: Color(0xFF6AA8FF),
            ),
            label: const Text(
              'Share E-Ticket',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color:
                    const Color(0xFF287CE5).withValues(alpha: .35),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// TICKET SHAPE
// ============================================================

class TicketPaperClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 24.0;
    const notch = 9.0;

    final path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, radius)
      ..lineTo(size.width, size.height * .47 - notch)
      ..arcToPoint(
        Offset(size.width, size.height * .47 + notch),
        radius: const Radius.circular(notch),
        clockwise: false,
      )
      ..lineTo(size.width, size.height - radius)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      )
      ..lineTo(radius, size.height)
      ..quadraticBezierTo(
        0,
        size.height,
        0,
        size.height - radius,
      )
      ..lineTo(0, size.height * .47 + notch)
      ..arcToPoint(
        Offset(0, size.height * .47 - notch),
        radius: const Radius.circular(notch),
        clockwise: false,
      )
      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant TicketPaperClipper oldClipper) => false;
}

class TicketPerforation extends StatelessWidget {
  const TicketPerforation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 18,
            decoration: const BoxDecoration(
              color: Color(0xFF03060B),
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
              ),
            ),
          ),
          const Expanded(
            child: CustomPaint(
              painter: PerforatedLinePainter(),
            ),
          ),
          Container(
            width: 8,
            height: 18,
            decoration: const BoxDecoration(
              color: Color(0xFF03060B),
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PerforatedLinePainter extends CustomPainter {
  const PerforatedLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5DC)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 9) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(
          math.min(x + 5, size.width),
          size.height / 2,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PerforatedLinePainter oldDelegate) => false;
}

class TicketShimmerPainter extends CustomPainter {
  final double progress;

  TicketShimmerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width * progress;
    final rect = Rect.fromLTWH(
      x - 55,
      -size.height,
      55,
      size.height * 3,
    );

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Color(0x25FFFFFF),
          Colors.transparent,
        ],
      ).createShader(rect);

    canvas.save();
    canvas.rotate(-.12);
    canvas.drawRect(rect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TicketShimmerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// ============================================================
// DEMO QR
// ============================================================

class FakeQrPainter extends CustomPainter {
  final String seed;

  FakeQrPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    const modules = 21;
    final unit = size.width / modules;

    final black = Paint()..color = Colors.black;
    final white = Paint()..color = Colors.white;

    final random = math.Random(
      seed.codeUnits.fold<int>(
        0,
        (a, b) => a + b,
      ),
    );

    canvas.drawRect(
      Offset.zero & size,
      white,
    );

    bool finder(int x, int y, int sx, int sy) {
      return x >= sx &&
          x < sx + 7 &&
          y >= sy &&
          y < sy + 7;
    }

    for (int y = 0; y < modules; y++) {
      for (int x = 0; x < modules; x++) {
        bool block = random.nextBool();

        if (finder(x, y, 0, 0) ||
            finder(x, y, 14, 0) ||
            finder(x, y, 0, 14)) {
          block = false;
        }

        if (block) {
          canvas.drawRect(
            Rect.fromLTWH(
              x * unit,
              y * unit,
              unit + .2,
              unit + .2,
            ),
            black,
          );
        }
      }
    }

    void drawFinder(int sx, int sy) {
      canvas.drawRect(
        Rect.fromLTWH(
          sx * unit,
          sy * unit,
          7 * unit,
          7 * unit,
        ),
        black,
      );

      canvas.drawRect(
        Rect.fromLTWH(
          (sx + 1) * unit,
          (sy + 1) * unit,
          5 * unit,
          5 * unit,
        ),
        white,
      );

      canvas.drawRect(
        Rect.fromLTWH(
          (sx + 2) * unit,
          (sy + 2) * unit,
          3 * unit,
          3 * unit,
        ),
        black,
      );
    }

    drawFinder(0, 0);
    drawFinder(14, 0);
    drawFinder(0, 14);
  }

  @override
  bool shouldRepaint(covariant FakeQrPainter oldDelegate) {
    return oldDelegate.seed != seed;
  }
}

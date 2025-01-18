import 'package:flutter/material.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/person_signature.dart';

class KilSignatureWidget extends StatelessWidget {
  const KilSignatureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ExpansionTile(
      title: const Text('Tanda Tangan'),
      leading: const Icon(Icons.create),
      children: [
        SizedBox(
          height: width + (width / 2),
          child: Column(
            children: [
              SizedBox(
                height: width / 2,
                width: width,
                child: Row(
                  children: [
                    Expanded(
                      child: PersonSignature(
                        title: 'MENGAJUKAN',
                        name: 'Nama Pelanggan',
                        position: 'PELANGGAN',
                        tgl: 'Tgl.',
                      ),
                    ),
                    Expanded(
                      child: PersonSignature(
                        title: 'DIAJUKAN',
                        name: 'Nama Sales',
                        position: 'ASM',
                        tgl: 'Tgl.',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width / 2,
                width: width,
                child: Row(
                  children: [
                    Expanded(
                      child: PersonSignature(
                        title: 'DIPERIKSA',
                        name: 'BENNY KRISMAS',
                        position: 'SMH',
                        tgl: 'Tgl.',
                      ),
                    ),
                    Expanded(
                      child: PersonSignature(
                        title: 'DISETUJUI',
                        name: 'RYAN HARRIS',
                        position: 'CEO',
                        tgl: 'Tgl.',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: width,
                  child: PersonSignature(
                    title: 'DISETUJUI',
                    name: 'RYAN HARRIS',
                    position: 'CEO',
                    tgl: 'Tgl.',
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

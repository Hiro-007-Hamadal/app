import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_viewmodel.dart';
import '../models/app_models.dart';

class MainScreen extends StatelessWidget {
  const MainScreen(super.key);

  @override
  Widget build(BuildContext context) {
    return const AttendanceView();
  }
}

class AttendanceView extends StatelessWidget {
const AttendanceView(super.key);

@override
Widget build(BuildContext context) {
final vm = Provider.of<AppViewModel>(context);

return Scaffold(
appBar: AppBar(
title: const Text('Monthly Roll Call Calculator'),
backgroundColor: Colors.indigo,
foregroundColor: Colors.white,
),
floatingActionButton: FloatingActionButton.extended(
onPressed: () => _showAddSubjectDialog(context, vm),
label: const Text('ဘာသာရပ်အသစ်ထည့်မည်'),
icon: const Icon(Icons.add),
backgroundColor: Colors.indigo,
foregroundColor: Colors.white,
),
body: vm.attendances.isEmpty
? const Center(
child: Text(
'ဘာသာရပ်များ မရှိသေးပါ။\n"+ ဘာသာရပ်အသစ်ထည့်မည်" ကိုနှိပ်ပါ။',
textAlign: TextAlign.center,
style: TextStyle(color: Colors.grey, fontSize: 16),
),
)
: ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: vm.attendances.length,
itemBuilder: (context, index) {
final item = vm.attendances[index];
final percent = item.percentage;
final isPassed = item.isEligible;

return Card(
margin: const EdgeInsets.only(bottom: 16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12)),
elevation: 3,
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Expanded(
child: Text(
item.subjectName,
style: const TextStyle(
fontSize: 18, fontWeight: FontWeight.bold),
),
),
IconButton(
icon: const Icon(Icons.edit_outlined, color: Colors.blue),
tooltip: 'ပြင်မည်',
onPressed: () => _showEditCountDialog(context, vm, item),
),
IconButton(
icon: const Icon(Icons.refresh, color: Colors.orange),
tooltip: 'လအသစ်အတွက် Reset ပြုလုပ်မည်',
onPressed: () => _showResetConfirmDialog(context, vm, item),
),
IconButton(
icon: const Icon(Icons.delete_outline, color: Colors.red),
onPressed: () => vm.deleteAttendanceSubject(item.id),
),
],
),
Text(
'🗓️ ၁ လ = ${item.weeksPerMonth} ပတ် | ၁ ပတ် = ${item.classesPerWeek} ချိန် (စုစုပေါင်း ${item.totalMonthlyClasses} ချိန်)',
style: TextStyle(color: Colors.grey[700], fontSize: 13),
),
const SizedBox(height: 10),
Row(
children: [
Container(
padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
decoration: BoxDecoration(
color: isPassed ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
borderRadius: BorderRadius.circular(20),
),
child: Text(
isPassed
? '✓ Roll Call ပြည့်ပါသည် (${percent.toStringAsFixed(1)}%)'
: '⚠️ Roll Call မပြည့်ပါ (${percent.toStringAsFixed(1)}%)',
style: TextStyle(
color: isPassed ? Colors.green : Colors.red,
fontWeight: FontWeight.bold,
),
),
),
],
),
const SizedBox(height: 8),
Text(
'💡 ၇၅% ပြည့်ရန် ၁ လလျှင် အများဆုံး ${item.maxAllowedAbsents} ချိန်အထိ ပျက်ခွင့်ရှိသည်။',
style: const TextStyle(fontSize: 12, color: Colors.deepOrangeAccent),
),
const SizedBox(height: 12),
LinearProgressIndicator(
value: item.totalClassesSoFar == 0 ? 1.0 : item.present / item.totalClassesSoFar,
backgroundColor: Colors.grey[300],
color: isPassed ? Colors.green : Colors.red,
minHeight: 8,
),
const SizedBox(height: 12),
Text(
'လက်ရှိကျောင်းတက်: ${item.present} ချိန်  |  ပျက်: ${item.absent} ချိန်  |  ပြီးစီး: ${item.totalClassesSoFar}/${item.totalMonthlyClasses} ချိန်',
style: const TextStyle(color: Colors.grey, fontSize: 13),
),
const Divider(height: 24),
Row(
children: [
Expanded(
child: ElevatedButton.icon(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green,
foregroundColor: Colors.white,
),
icon: const Icon(Icons.check_circle_outline),
label: const Text('ကျောင်းတက်သည်'),
onPressed: () => vm.markPresent(item.id),
),
),
const SizedBox(width: 8),
Expanded(
child: OutlinedButton.icon(
style: OutlinedButton.styleFrom(
foregroundColor: Colors.red,
side: const BorderSide(color: Colors.red),
),
icon: const Icon(Icons.cancel_outlined),
label: const Text('ပျက်သည်'),
onPressed: () => vm.markAbsent(item.id),
),
),
],
),
],
),
),
);
},
),
);
}

void _showAddSubjectDialog(BuildContext context, AppViewModel vm) {
final nameController = TextEditingController();
final weeksController = TextEditingController(text: '4');
final classesController = TextEditingController(text: '3');showDialog(
context: context,
builder: (ctx) => AlertDialog(
title: const Text('ဘာသာရပ် အချက်အလက် ထည့်ရန်'),
content: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(
controller: nameController,
decoration: const InputDecoration(
labelText: 'ဘာသာရပ်အမည် (ဥပမာ- Calculus)',
border: OutlineInputBorder(),
),
),
const SizedBox(height: 12),
TextField(
controller: weeksController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: 'တစ်လလျှင် ရှိသည့် ပတ်အရေအတွက်',
border: OutlineInputBorder(),
),
),
const SizedBox(height: 12),
TextField(
controller: classesController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: 'တစ်ပတ်လျှင် ရှိသည့် အတန်းချိန်',
border: OutlineInputBorder(),
),
),
],
),
actions: [
TextButton(
onPressed: () => Navigator.pop(ctx),
child: const Text('မလုပ်တော့ပါ'),
),
ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
onPressed: () {
if (nameController.text.isNotEmpty) {
final weeks = int.tryParse(weeksController.text) ?? 4;
final classes = int.tryParse(classesController.text) ?? 3;
vm.addAttendanceSubject(nameController.text, weeks, classes);
Navigator.pop(ctx);
}
},
child: const Text('သိမ်းမည်', style: TextStyle(color: Colors.white)),
),
],
),
);
}

void _showResetConfirmDialog(BuildContext context, AppViewModel vm, AttendanceRecord item) {
showDialog(
context: context,
builder: (ctx) => AlertDialog(
title: Text('${item.subjectName} ကို Reset လုပ်မည်လော?'),
content: const Text('လအသစ် စတင်ရန်အတွက် အတန်းတက်/ပျက် မှတ်တမ်းများကို 0 သို့ ပြန်စပါမည်။'),
actions: [
TextButton(
onPressed: () => Navigator.pop(ctx),
child: const Text('မလုပ်တော့ပါ'),
),
ElevatedButton(
style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
onPressed: () {
vm.resetAttendance(item.id);
Navigator.pop(ctx);
},
child: const Text('Reset ပြုလုပ်မည်', style: TextStyle(color: Colors.white)),
),
],
),
);
}

void _showEditCountDialog(BuildContext context, AppViewModel vm, AttendanceRecord item) {
final presentController = TextEditingController(text: item.present.toString());
final absentController = TextEditingController(text: item.absent.toString());

showDialog(
context: context,
builder: (ctx) => AlertDialog(
title: Text('${item.subjectName} အကြိမ်ရေ ပြင်ရန်'),
content: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(
controller: presentController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: 'ကျောင်းတက်သည့် အကြိမ်ရေ',
border: OutlineInputBorder(),
),
),
const SizedBox(height: 12),
TextField(
controller: absentController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: 'ကျောင်းပျက်သည့် အကြိမ်ရေ',
  border: OutlineInputBorder(),
),
),
],
),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(ctx),
      child: const Text('မလုပ်တော့ပါ'),
    ),
    ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: () {
        final present = int.tryParse(presentController.text) ?? item.present;
        final absent = int.tryParse(absentController.text) ?? item.absent;
        vm.updateAttendanceCount(item.id, present, absent);
        Navigator.pop(ctx);
      },
      child: const Text('ပြင်ဆင်မည်', style: TextStyle(color: Colors.white)),
    ),
  ],
),
);
}
}
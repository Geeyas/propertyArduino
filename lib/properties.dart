class MyData {
  final String createdAt;
  final String href;
  final String id;
  final String lastValue;
  final String name;
  final String permission;
  final bool persist;
  final String tag;
  final String thingId;
  final String thingName;
  final String type;
  final String updateStrategy;
  final String updatedAt;
  final String valueUpdatedAt;
  final String variableName;

  MyData({
    required this.createdAt,
    required this.href,
    required this.id,
    required this.lastValue,
    required this.name,
    required this.permission,
    required this.persist,
    required this.tag,
    required this.thingId,
    required this.thingName,
    required this.type,
    required this.updateStrategy,
    required this.updatedAt,
    required this.valueUpdatedAt,
    required this.variableName,
  });

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      createdAt: json['created_at'],
      href: json['href'],
      id: json['id'],
      lastValue: json['last_value'],
      name: json['name'],
      permission: json['permission'],
      persist: json['persist'],
      tag: json['tag'].toString(),
      thingId: json['thing_id'],
      thingName: json['thing_name'],
      type: json['type'],
      updateStrategy: json['update_strategy'],
      updatedAt: json['updated_at'],
      valueUpdatedAt: json['value_updated_at'],
      variableName: json['variable_name'],
    );
  }
}

 
// Card(
// child: ListTile(
// title: Text(
// 'Created At : \n ${prpData?.createdAt}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Href : \n ${prpData?.href}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'ID : \n ${prpData?.id}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Last value : ${prpData?.lastValue}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Name : ${prpData?.name}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Permission : ${prpData?.permission}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Persist : ${prpData?.persist}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Tag : ${prpData?.tag}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Thing ID : ${prpData?.thingId}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Thing name : ${prpData?.thingName}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Type : ${prpData?.type}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Update Strategy: ${prpData?.updateStrategy}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Updated At: ${prpData?.updatedAt}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Value Updated At: ${prpData?.valueUpdatedAt}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
// Card(
// child: ListTile(
// title: Text(
// 'Variable Name: ${prpData?.variableName}',
// style: const TextStyle(fontSize: 18),
// ),
// ),
// ),
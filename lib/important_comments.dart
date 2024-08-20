// 1. if (widget.formkey.currentState!.validate()) {
// Explanation: Yeh check karta hai ke form valid hai ya nahi. validate() method form ke sabhi fields ko validate karta hai. Agar sabhi fields valid hain, to true return karta hai.


// 2. setState(() { api.setLoading(true); });
// Explanation: Yeh state ko update karta hai aur api object me loading state ko true set karta hai. Yeh UI me circular progress indicator ko dikhane ke liye hai.


// 3. final response = await api.registerUser({...});
// Explanation: Yeh API call karta hai user ko register karne ke liye. Yeh asynchronous call hai isliye await use kiya gaya hai.


// 4. if (response is String) {
// Explanation: Yeh check karta hai ke response ka type String hai ya nahi. API se jo response aata hai, wo generally JSON string hota hai.

// Reason: Aap yeh check karte hain ke response JSON string format me hai, taake aap usko decode kar sakein.


// 5. final decodedResponse = jsonDecode(response);
// Explanation: Yeh line JSON string ko Dart object me convert karti hai taake aap uske properties ko access kar sakein.

// Reason for placing it inside if (response is String): Aap pehle check karte hain ke response string hai, phir usko decode karte hain. Agar response string nahi hota, to decoding fail ho sakti hai aur error throw ho sakta hai.



// Full Workflow Explanation
// Form Validation: Sabse pehle, aap form ko validate karte hain.
// Loading State: Agar form valid hai, to loading state ko true set karte hain.
// API Call: API call hota hai user ko register karne ke liye.
// Response Type Check: API se jo response milta hai, uska type check karte hain.
// JSON Decoding: Agar response string hai, to usko JSON me decode karte hain.
// Response Handling: Decoded response se status code aur message ko check karte hain aur accordingly alert show karte hain.
// Clear Fields and Update State: Success hone par fields ko clear karte hain aur loading state ko false set karte hain.









// Internet Connectivity

// Method Declaration: Future<bool> return type aur async keyword ke saath method declare kiya.
// Try-Catch Block: Network request ko try block me perform kiya aur exception handle kiya.
// Internet Address Lookup: example.com domain name ke through network connectivity check kiya.
// Check Result: Response ko check karke boolean value return ki.
// Handle Exception: Network issue handle kiya aur false return kiya.
// Default Return: Safe value ensure karne ke liye false return kiya.
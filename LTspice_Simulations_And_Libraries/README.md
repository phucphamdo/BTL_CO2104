# STT 3: Thư mục file mô phỏng LTspice và thư viện bổ sung

**Yêu cầu nộp theo Bảng 3 đề bài:** Định dạng nộp `.zip`

## 📁 Cấu trúc thư mục:
```
LTspice_Simulations_And_Libraries/
├── sim/                           # 72 file schematic (.asc) & netlist (.cir)
│   ├── Lab1/                      # Ex01.asc - Ex10.asc, Ex11.asc, Ex12.asc
│   ├── Lab2/
│   ├── Lab3/
│   ├── Lab4/
│   ├── Lab5/
│   └── Lab6/
├── extra_libraries/               # Thư viện linh kiện bổ sung (nếu có)
│   ├── models/                    # File model SPICE (.model, .lib)
│   ├── subcircuits/               # Mạch con hành vi (.sub, .cir)
│   └── symbols/                   # Biểu tượng linh kiện tùy biến (.asy)
├── export_zip.ps1                 # Script tự động đóng gói thành file .zip để nộp
└── README.md
```

## 📦 Cách tạo file `.zip` nộp bài:
Chạy script PowerShell `export_zip.ps1`:
```powershell
.\export_zip.ps1
```
Script sẽ tự động nén toàn bộ thư mục `sim/` và `extra_libraries/` thành file:
`LTspice_Simulations_And_Libraries.zip` ngay tại đây để sẵn sàng nộp bài.

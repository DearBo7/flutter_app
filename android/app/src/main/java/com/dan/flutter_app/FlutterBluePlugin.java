package com.dan.flutter_app;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.os.Build;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * @version 1.0
 * @author: Bo
 * @fileName: FlutterPluginToBluetooth
 * @createDate: 2019-09-29 16:27.
 * @description: 蓝牙插件-https://github.com/1144075799/flutter_bluetooth
 */
@SuppressLint("Registered")
public class FlutterBluePlugin implements MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {
    public static String CHANNEL = "bo.flutter.io/bluetooth";

    private BluetoothAdapter myBluetoothAdapter = null;

    private Activity activity;

    private final static int REQUEST_CODE_OPEN = 777;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        FlutterBluePlugin instance = new FlutterBluePlugin(registrar.activity());
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
        //添加返回监听
        registrar.addActivityResultListener(instance);
    }

    private FlutterBluePlugin(Activity activity) {
        this.activity = activity;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR) {
            this.myBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        }
    }

    private MethodChannel.Result openResult;

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (openResult != null) {
            openResult = null;
        }
        switch (methodCall.method) {
            case "isAvailable":
                //是否支持蓝牙
                result.success(supportBluetooth());
                break;
            case "openBluetooth":
                //打开蓝牙-如果跳出打开蓝牙,结果就在监听返回
                boolean bluetoothFlag = openBluetooth();
                if (!bluetoothFlag) {
                    result.success(false);
                } else {
                    openResult = result;
                }
                break;
            case "isOpen":
                //蓝牙是否打开
                result.success(isOpen());
                break;
            case "getPairDeviceList":
                //获取已配对列表
                List<Map<String, Object>> pairDeviceList = getPairDeviceList();
                result.success(pairDeviceList);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    //是否支持蓝牙
    private boolean supportBluetooth() {

        return myBluetoothAdapter != null;
    }

    //打开蓝牙
    private boolean openBluetooth() {
        //判断蓝牙是否开启
        Intent intent = null;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR) {
            intent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
        }
        if (intent != null) {
            activity.startActivityForResult(intent, REQUEST_CODE_OPEN);
            return true;
        }
        return false;
    }

    //判断蓝牙是否已经开启
    private boolean isOpen() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR && myBluetoothAdapter != null) {
            return myBluetoothAdapter.isEnabled();
        }
        return false;
    }

    //获取蓝牙设备配对列表
    private List<Map<String, Object>> getPairDeviceList() {
        List<Map<String, Object>> bluetoothEntityList = new ArrayList<>();
        if (isOpen()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR) {
                Set<BluetoothDevice> bondedDevices = myBluetoothAdapter.getBondedDevices();
                if (bondedDevices.size() < 1) {
                    return bluetoothEntityList;
                }
                Map<String, Object> bluetoothMap;
                for (BluetoothDevice device : bondedDevices) {
                    bluetoothMap = new HashMap<>();
                    bluetoothMap.put("name", device.getName());
                    bluetoothMap.put("address", device.getAddress());
                    bluetoothEntityList.add(bluetoothMap);
                }
                return bluetoothEntityList;
            }
        }
        return bluetoothEntityList;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        //System.out.println("requestCode:" + requestCode + ",resultCode:" + resultCode);
        if (REQUEST_CODE_OPEN == requestCode && openResult != null) {
            //System.out.println("onActivityResult===>openResult");
            openResult.success(resultCode == -1);
        }
        return false;
    }
}
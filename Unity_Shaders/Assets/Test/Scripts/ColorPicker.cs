using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Test
{
    [RequireComponent(typeof(Camera))]
    public class ColorPicker : MonoBehaviour
    {
        /// <summary>
        /// 颜色显示面板
        /// </summary>
        private Texture2D _board;
        private bool _grab = false;
        private Color _color;
        private GUIStyle _guiStyle;
        public GameObject[] Test;
        public Color m_Color;
        [Range(0,1)]
        public float R = 0.5f;
        void Start()
        {
            _board = new Texture2D(1,1);
            _guiStyle = new GUIStyle();
           
        }
        [ContextMenu("查找")]
        void Find()
        {
            var go = GameObject.Find("Test/Go");
            var go1 = GameObject.Find("Test");
            int kge = 0;
        }
        // Update is called once per frame
        void Update()
        {
            m_Color = new Color(0.5f, R, 0.5f);
        }
        /// <summary>
        /// 必须在渲染帧里读取像素
        /// </summary>
        private void OnPostRender()
        {
            if(_grab)
            {
                _grab = false;
                var tmp = new Texture2D(Screen.width, Screen.height);
                tmp.ReadPixels(new Rect(0, 0, Screen.width, Screen.height), 0, 0);
                tmp.Apply();
               _color = tmp.GetPixel((int)Input.mousePosition.x,(int)Input.mousePosition.y);
                Object.Destroy(tmp);
                _board.SetPixel(0, 0, _color);
                _board.Apply();
                _guiStyle.normal.background = _board;
            }
        }
        private void OnGUI()
        {
            GUI.Box(new Rect(0, 0, 120, 200), "Color Picker");
            GUI.Box(new Rect(20, 30, 80, 80),GUIContent.none,_guiStyle);
            GUI.Label(new Rect(10, 120, 100, 20), "R: " + System.Math.Round((double)_color.r, 4) + "\t(" + Mathf.FloorToInt(_color.r * 255) + ")");
            GUI.Label(new Rect(10, 140, 100, 20), "G: " + System.Math.Round((double)_color.g, 4) + "\t(" + Mathf.FloorToInt(_color.g * 255) + ")");
            GUI.Label(new Rect(10, 160, 100, 20), "B: " + System.Math.Round((double)_color.b, 4) + "\t(" + Mathf.FloorToInt(_color.b * 255) + ")");
            GUI.Label(new Rect(10, 180, 100, 20), "A: " + System.Math.Round((double)_color.a, 4) + "\t(" + Mathf.FloorToInt(_color.a * 255) + ")");
            if (Input.GetMouseButtonDown(0))
            {
                _grab = true;
            }
        }
    }
}



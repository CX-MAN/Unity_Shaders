using UnityEngine;
public class Example : MonoBehaviour
{
    void Start()
    {
        // Make a game object
        GameObject probeGameObject = new GameObject("The Reflection Probe");

        // Add the reflection probe component
        ReflectionProbe probeComponent = probeGameObject.AddComponent<ReflectionProbe>() as ReflectionProbe;

        // Set texture resolution
        probeComponent.resolution = 256;

        // Reflection will be used for objects in 10 units around the position of the probe
        probeComponent.size = new Vector3(10, 10, 10);

        // Set the position (or any transform property)
        probeGameObject.transform.position = new Vector3(0, 5, 0);
        probeComponent.refreshMode = UnityEngine.Rendering.ReflectionProbeRefreshMode.ViaScripting;
        probeComponent.RenderProbe();
    }
}

using UnityEngine;

public class StuffSpawnerRing : MonoBehaviour
{

    public Material[] materials;
    
    public int numberOfSpawners;

    public float radius, tiltAngle;

    public StuffSpawner spawnerPrefab;

    void Awake()
    {
        for (int i = 0; i < numberOfSpawners; i++)
        {
            CreateSpawner(i);
        }
    }

    void CreateSpawner(int index)
    {
        Transform rotater = new GameObject("Rotater").transform;
        rotater.SetParent(transform, false);
        rotater.localRotation =
            Quaternion.Euler(0f, index * 360f / numberOfSpawners, 0f);

        StuffSpawner spawner = Instantiate<StuffSpawner>(spawnerPrefab);
        spawner.stuffMaterial = materials[index % materials.Length];
        
        spawner.transform.SetParent(rotater, false);
        spawner.transform.localPosition = new Vector3(0f, 0f, radius);
        spawner.transform.localRotation = Quaternion.Euler(tiltAngle, 0f, 0f);
    }
}
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InstancedGrass : MonoBehaviour
{
    [SerializeField, Tooltip("Grass blade mesh")]
    private Mesh mesh;

    [SerializeField, Min(0), Tooltip("Width of the grass field")] 
    float width;

    [SerializeField, Min(1), Tooltip("How many grass blades to render")]
    int density;

    [SerializeField, Tooltip("Grass shader")]
    Shader shader;

    RenderParams renderParams = new RenderParams();
    Material material;

    static readonly int positionsId = Shader.PropertyToID("_Positions");

    private void OnEnable()
    {
        material = new Material(shader);
        renderParams.material = material;
        material.SetFloat("_Width", width);
        material.SetInt("_Density", density);
    }

    private void OnDisable()
    {
        Destroy(material);
        material = null;
    }

    private void Update()
    {
        Graphics.RenderMeshPrimitives(renderParams, mesh, 0, density);
    }
}
